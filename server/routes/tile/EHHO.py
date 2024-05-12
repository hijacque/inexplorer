import numpy as np
from time import time
import random as rand
from shapely.geometry import LineString, MultiPolygon

from ppl import Path, generate_randpaths, euclidean_distance
import HHO

# OBJECTIVE 2: Linearize path to reduce unnecessary turns
def linear_path_strategy(path, obstacles):
    total_nodes = len(path)
    i = 0
    line_path = list(path)
    while i < total_nodes - 2:
        node1 = line_path[i]
        node2 = line_path[i + 2]
        sub_path = LineString([node1, node2])

        if not sub_path.intersects(obstacles):
            line_path.pop(i+1) # remove middle node
            total_nodes -= 1
        else:
            i += 1
    
    return np.array(line_path)

def path_length_and_travel_time(path):
    travel_time = 0
    length = 0
    for i in range(0, len(path) - 1):
        distance = euclidean_distance(path[i], path[i+1])
        # average walking speed: 1.34 m/s
        # average walking speed upstairs: 0.5 m/s
        # average walking speed downstairs: 0.8 m/s

        travel_time += distance * 1.34 # walking speed
        length += distance

    # return dist_weight * length + time_weight * travel_time
    return length, travel_time

def exponential_rank(population, c=0.99):
    total_population = len(population)
    # Calculate selection probabilities (-c: for minimization, +c: for maximization)
    selection_probs = [np.exp(-c * population[i].fitness) for i in range(total_population)]
    selection_probs /= np.sum(selection_probs)

    # Select individuals based on probabilities
    selected_indices = np.random.choice(total_population, size=total_population, p=selection_probs)

    # Return the selected individual
    return population[selected_indices[rand.randrange(0, total_population)]]

def plan_path(start, goal, map_bounds, max_iter=1, total_hawks=0, obstacles:MultiPolygon=None, step=1, objectives=[]):
    """
    path planning processes uising HHO algorithm
    """

    # Start execution timer
    timer_start = time()

    # Initialize population of feasible hawks (hawks)
    hawks, nodes = generate_randpaths(total_hawks, start,goal, map_bounds, obstacles, step=step)
    hawks = [Path(path, obstacles, objectives) for path in hawks]
    
    # Get the current best solution
    prey = HHO.update_prey(hawks)

    # Initialize convergence
    convergence = np.zeros(max_iter)

    # Initialize prey's energy
    prey_energy = float("inf")  # change this to -inf for maximization problems

    t = 0 # iteration counter
    while t < max_iter:
        # plot current best solution in convergence curve
        convergence[t] = prey.fitness

        E1 = 2 * (1 - (t / max_iter))
        # Update the path's found by hawks
        for i in range(total_hawks):
            if hawks[i] == prey:
                continue
            
            E0 = 2 * rand.random() - 1
            prey_energy = E1 * E0

            # ---------------------------  Exploration Phase  ---------------------------
            if abs(prey_energy) >= 1:
                # Harris hawks perch/explore randomly based on 2 strategies
                q = rand.random()

                # -------  Explore based on selected hawk using Exponetial rank  --------
                if q >= 0.5:
                    # perch based on other family members
                    # OBJECTIVE 1: explore based on hawk selected using exploenential rank
                    rhawk = exponential_rank(hawks)
                    hawk = hawks[i]

                    updated_path = HHO.perch_on_hawk(hawk.path, rhawk.path, start, goal, step=step)
                    hawk.update(updated_path, obstacles)

                # -----------------------  Explore within range  ------------------------
                elif q < 0.5:
                    # perch on a random tall tree (random site inside group's home range)
                    avg_hawk = HHO.average_path([hawk.path for hawk in hawks], start, goal)
                    updated_path = HHO.perch_on_hawk(avg_hawk, prey.path, start, goal, step=step)
                    hawks[i].update(updated_path, obstacles)
            
            # ---------------------------  Exploration Phase  ---------------------------
            elif prey_energy < 1:
                escape_probability = rand.random()
                
                # ---------------------------  Soft Besiege  ----------------------------
                if prey_energy >= 0.5 and escape_probability >= 0.5:
                    # print(f'Exploit using Soft Besiege...({t})')
                    jump_strength = 2 * (1 - rand.random()) # possible offset of prey's location if it successfully escapes
                    hawk = hawks[i]
                    updated_path = HHO.soft_besiege(
                        hawk.path, prey.path, prey_energy, jump_strength, start, goal, step=step
                    )
                    hawk.update(updated_path, obstacles)

                # ---------------------------  Hard Besiege  ----------------------------
                elif prey_energy < 0.5 and escape_probability >= 0.5:
                    # print(f'Exploit using Hard Besiege...({t})')
                    hawk = hawks[i]
                    updated_path = HHO.hard_besiege(
                        hawk.path, prey.path, prey_energy, start, goal, step=step
                    )
                    hawk.update(updated_path, obstacles)
                
                # -------------------  Soft Besiege with rapid dives  -------------------
                elif prey_energy >= 0.5 and escape_probability < 0.5:
                    jump_strength = 2 * (1 - rand.random()) # possible offset of prey's location if it successfully escapes
                    hawk = hawks[i]
                    updated_path = HHO.soft_besiege_with_dives(
                        hawk.path, prey.path, prey_energy, jump_strength, start, goal, step=step
                    )
                    hawk.update(updated_path, obstacles)
                
                # -------------------  Hard Besiege with rapid dives  -------------------
                elif prey_energy < 0.5 and escape_probability < 0.5:
                    jump_strength = 2 * (1 - rand.random()) # possible offset of prey's location if it successfully escapes
                    avg_hawk = HHO.average_path([hawk.path for hawk in hawks], start, goal)
                    hawk = hawks[i]

                    updated_path = HHO.hard_besiege_with_dives(
                        hawk.path, avg_hawk, prey.path, prey_energy, jump_strength, start, goal, step=step
                    )
                    hawk.update(updated_path, obstacles)
        
        # temporarily get current best path
        temp_prey = HHO.update_prey(hawks, prey)
        # fix collisions
        refined_path = HHO.refine_path(temp_prey.path, nodes, start, goal, obstacles, step)
        # OBJECTIVE 2: reduce unecessary turns and path length using Linear Path Strategy
        temp_prey.update(linear_path_strategy(refined_path, obstacles), obstacles)
        if temp_prey < prey:
            prey = temp_prey

        t += 1

    runtime = time() - timer_start
    return prey, runtime, convergence