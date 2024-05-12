from math import radians, sin, cos, sqrt, atan2
import heapq as hq
import numpy as np
import random as rand

from shapely import LineString, Point, Polygon, MultiPolygon

class Path:
    def __init__(self, path=None, nodes:dict={}, waypoints:dict={}, objectives:list=[]):
        self.path = path
        self.objectives = objectives
        self.costs = {}
        for obj in objectives:
            self.costs[obj['name']] = None
        
        if path is None:
            self.fitness = float('inf')
        else:
            self.fitness = self.get_fitness(nodes, waypoints)
    
    def get_fitness(self, nodes:dict, waypoints:dict):
        total_weight = sum(obj['weight'] for obj in self.objectives)
        weighted_cost = 0
        for obj in self.objectives:
            if obj['name'] == 'path length':
                cost = obj['function'](self.path, waypoints)
            elif obj['name'] == 'travel time':
                cost = obj['function'](self.path, nodes, waypoints)
            else:
                cost = obj['function'](self.path)
            
            self.costs[obj['name']] = cost
            weighted_cost += obj['weight'] * cost
        
        return weighted_cost / total_weight
    
    def update(self, path, nodes:dict, waypoints:dict):
        self.path = path
        self.fitness = self.get_fitness(nodes, waypoints)
    
    def __lt__(self, other):
        return self.fitness < other.fitness
    
    def __gt__(self, other):
        return self.fitness > other.fitness
    
class Node:
    def __init__(self, id:int, neighbors:dict=None):
        self.id = id
        self.neighbors = neighbors
    
    def __eq__(self, other):
        return self.id == other.id

class Edge:
    def __init__(self, node, parent_node=None, g=0, h=0):
        self.parent_id = parent_node
        self.node_id = node
        self.g = g
        self.h = h
    
    def __lt__(self, other):
        return (self.g + self.h) < (other.g + other.h)
    
def haversine(lat1, lng1, lat2, lng2):
    R = 6371.0  # Earth radius in kilometers

    lat1 = radians(lat1)
    lon1 = radians(lng1)
    lat2 = radians(lat2)
    lon2 = radians(lng2)

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))

    distance = R * c
    return distance

def convert_latlng(lat, lng, map_width, map_height):
    # Convert latitude and longitude to meters
    x = lng * (map_width / 360.0)
    y = lat * (map_height / 180.0)
    return (x, y)

def euclidean_distance(start_pos, goal_pos, start_floor=1, goal_floor=1):
    """Compute distance from start to goal using euclidean formula."""
    floors_dist = abs(goal_floor - start_floor) * 6
    return sqrt(pow(goal_pos[0] - start_pos[0], 2) + pow(goal_pos[1] - start_pos[1], 2)) + floors_dist

def path_length(path:list, waypoints:dict):
    """Compute the summation of all edges' length."""
    if path is None:
        return 0
    
    length = 0
    for i in range(0, len(path) - 1):
        node1 = path[i]
        node2 = path[i + 1]
        length += waypoints[node1][node2]['length']
    
    return length

def travel_time(path:list, nodes:dict, waypoints:dict):
    travel_time = 0
    for i in range(0, len(path) - 1):
        node1 = path[i]
        node2 = path[i + 1]
        distance = waypoints[node1][node2]['length']
        mode = waypoints[node1][node2]['mode']
        if mode == 'walk':
            travel_time += distance * 1.34 # walking speed: 1.34 meters per second
        elif mode == 'stairs' and nodes[node1]['level'] < nodes[node2]['level']:
            travel_time += distance * 0.5 # walking speed upstairs: 0.5 meters per second
        elif mode == 'stairs' and nodes[node1]['level'] > nodes[node2]['level']:
            travel_time += distance * 0.8 # walking speed downstairs: 0.8 meters per second
        else:
            travel_time += distance

    return travel_time

def generate_randpaths(total_paths:int, start:int, goal:int, nodes:dict, waypoints:dict, heuristic=euclidean_distance):
    """
    Generates paths based on A* with a random heuristic
    """
    paths = [] # list of random paths generated
    print(start, goal)
    for i in range(total_paths):
        open_set = [] # list of available nodes
        closed_set = set() # list of nodes already visited (no duplicates)

        # place the first edge of the path
        hq.heappush(open_set, Edge(start, g=0))
        
        # keep searching while there are still open nodes
        while open_set:
            current = hq.heappop(open_set)

            # check if goal node is already reached
            if current.node_id == goal:
                # trace back complete path
                path_nodes = []
                while current:
                    # node = current_open.node.coord
                    path_nodes.append(current.node_id)
                    # current_open = current_open.parent
                    current = current.parent_id
                
                path_nodes.reverse()
                paths.append(path_nodes)
                break
            
            closed_set.add(current.node_id) # add current node to list of visited nodes

            # Check current node for surrounding available points
            neighbors = waypoints[current.node_id]
            if not neighbors:
                # skip search iteration
                continue
            
            # print(current.node_id, '-->', neighbors.keys())
            for neighbor_id in neighbors:
                # Check if node is already part of the path
                if neighbor_id in closed_set:
                    continue
                
                h = heuristic(nodes[neighbor_id]['coord'], nodes[goal]['coord']) + abs(nodes[neighbor_id]['level'] - nodes[goal]['level']) * 6
                new_open = Edge(
                    neighbor_id, parent_node=current,
                    g=neighbors[neighbor_id]['length'],
                    # h=(h * rand.uniform(0, 2)) # randomizes path generated
                    h=rand.uniform(0, 2)
                )
                # Check if neighbor is open to be part of the path
                if new_open not in open_set:
                    hq.heappush(open_set, new_open)
    
    return paths