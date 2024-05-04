from django.shortcuts import render
from django.http import HttpResponse, JsonResponse, HttpResponseBadRequest, HttpResponseNotFound

from django.db import connection
import json

def execute_query(query:str):
    with connection.cursor() as cursor:
        cursor.execute(query)
        columns = [col[0] for col in cursor.description]
        rows = cursor.fetchall()
        if rows:
            result = [dict(zip(columns, row)) for row in rows]
            return result
        else:
            return None

def tile(req, map_id, z, x, y):
    tile_path = f'../tiles/{map_id}/{z}/{x}/{y}.png'
    try:
        with open(tile_path, 'rb') as tile_file:
            return HttpResponse(tile_file.read(), content_type="image/png")
    except IOError:
        return JsonResponse({
            'status': 400,
            'body': 'Invalid map tile request.'
        })

def search(req):
    map_id = req.GET.get('map_id', None)
    if map_id is None:
        return JsonResponse({
            'status': 400,
            'body': 'Map ID required.'
        })
    
    try:
        map_id = int(map_id)
    except:
        return JsonResponse({
            'status': 400,
            'body': 'Invalid map ID.'
        })
    
    deep_search = bool(req.GET.get('deep', False))
    q = req.GET.get('q', None)
    if not deep_search:
        if q is None:
            # get all elements in the current map
            elem_ids = execute_query(
                f'SELECT id FROM Element WHERE map_id = {map_id} AND tags LIKE "%amenity%" ORDER BY type;'
            )
        else:
            # get related elements in the current map
            q = str(q).lower().split(' ')
            elem_ids = execute_query(
                f'SELECT id FROM Element WHERE map_id = {map_id} AND tags LIKE "%amenity%" AND ' +
                f'LOWER(tags) LIKE "%{"%".join(q)}%" ORDER BY type;'
            )
        
        if elem_ids is None:
            return JsonResponse({'status': 200, 'body': []})
        else:
            elem_ids = [elem['id'] for elem in elem_ids]
        
    else:
        # get all the elements in all indoor maps (i.e. include elements in the grounds, buildings, rooms, etc.)
        root_map = execute_query(
            f'WITH RECURSIVE MapTree AS (SELECT id, parent_map_id FROM map WHERE id = {map_id} UNION ALL ' +
            'SELECT m.id, m.parent_map_id FROM map m JOIN MapTree mt ON m.id = mt.parent_map_id) ' +
            'SELECT id FROM MapTree WHERE parent_map_id IS NULL;'
        )

        if root_map is None:
            return JsonResponse({
                'status': 400,
                'body': f'Indoor location is not supported with the map ID: {map_id}.'
            })
        else:
            root_map = root_map[0]['id']
        
        indoor_maps = execute_query(
            f'WITH RECURSIVE MapHierarchy AS (SELECT id, parent_map_id FROM map WHERE id = {root_map} UNION ALL ' +
            'SELECT m.id, m.parent_map_id FROM map m JOIN MapHierarchy mh ON m.parent_map_id = mh.id) ' +
            'SELECT m.id, m.level, m.parent_map_id from Map m INNER JOIN MapHierarchy mh ON m.id = mh.id ' +
            'ORDER BY m.id, m.level;'
        )

        map_ids = [map['id'] for map in indoor_maps]
        if q is None:
            elem_ids = execute_query(
                f'SELECT id FROM Element WHERE map_id IN ({", ".join(str(id) for id in map_ids)}) AND ' +
                f'tags LIKE "%amenity%" ORDER BY type;'
            )
        else:
            q = str(q).lower().split(" ")
            elem_ids = execute_query(
                f'SELECT id FROM Element WHERE map_id IN ({", ".join(str(id) for id in map_ids)}) AND ' +
                f'tags LIKE "%amenity%" AND LOWER(tags) LIKE "%{"%".join(q)}%" ORDER BY type;'
            )

        if elem_ids is None:
            return JsonResponse({'status': 200, 'body': []})
        else:
            elem_ids = [elem['id'] for elem in elem_ids]
    
    try:
        elements = get_elements(elem_ids, False)
    except Exception as error:
        print(repr(error))
        return JsonResponse({
            'status': 500,
            'body': 'Unexpected error found.'
        })
    
    for i in range(len(elements)):
        elem = elements[i]
        tags = elem.pop('tags')
        
        category = tags['amenity']
        if category == 'comfort_room':
            elements[i]['name'] = str(tags['gender']).capitalize() + ' comfort room'
        elif tags['name']:
            elements[i]['name'] = tags['name']
        
        address = tags.get('addr', None)
        if address is not None:
            elements[i]['addr'] = address
        
        elements[i]['category'] = category

    return JsonResponse({
        'status': 200,
        'body': elements
    })

def search_bounds(req):
    bounds = str(req.GET.get('bounds', None)).split(',')
    try:
        bounds = [float(bound) for bound in bounds]
    except:
        return JsonResponse({
            'status': 400,
            'body': 'Invalid map bounds.'
        })
    
    map_id = req.GET.get('map_id', 0)
    try:
        map_id = int(map_id)
        if map_id == 0:
            raise Exception('Indoor map does not exist.')
    except:
        return JsonResponse({
            'status': 400,
            'body': 'Invalid map ID.'
        })
    
    elements = execute_query(
        'SELECT n.id, "node" AS type, e.tags, n.lat, n.lng FROM Element e INNER JOIN Node n ON ' +
        f'e.id = CONCAT("N", n.id) WHERE e.map_id = {map_id} AND e.tags IS NOT NULL AND e.tags LIKE "%amenity%" ' +
        f'AND (n.lat BETWEEN {bounds[0]} AND {bounds[2]}) AND (n.lng BETWEEN {bounds[1]} AND {bounds[3]});'
    ) or []

    elements += execute_query(
        'SELECT w.id, "way" AS type, e.tags, w.lat, w.lng, w.min_lat, w.min_lng, w.max_lat, w.max_lng FROM ' +
        'Element e INNER JOIN Way w ON e.id = CONCAT("W", w.id) ' +
        f'WHERE e.map_id = {map_id} AND e.tags IS NOT NULL AND e.tags LIKE "%amenity%" ' +
        f'AND (w.lat BETWEEN {bounds[0]} AND {bounds[2]}) AND (w.lng BETWEEN {bounds[1]} AND {bounds[3]});'
    ) or []

    elements += execute_query(
        'SELECT r.id, "relation" AS type, e.tags, r.lat, r.lng, r.lng, r.min_lat, r.min_lng, r.max_lat, ' +
        'r.max_lng FROM Element e INNER JOIN Relation r ON e.id = CONCAT("R", r.id) WHERE ' +
        f'e.map_id = {map_id} AND e.tags IS NOT NULL AND e.tags LIKE "%amenity%" AND ' +
        f'(r.lat BETWEEN {bounds[0]} AND {bounds[2]}) AND (r.lng BETWEEN {bounds[1]} AND {bounds[3]});'
    ) or []

    for i in range(len(elements)):
        elem = elements[i]
        
        if elem['tags']:
            elements[i]['tags'] = json.loads(f'{{{elem["tags"]}}}')
        
        if elem['type'] == 'node':
            elem_bounds = [
                elem['lat'], elem['lng'],
                elem['lat'], elem['lng']
            ]
        else:
            elem_bounds = [
                elements[i].pop('min_lat'), elements[i].pop('min_lng'),
                elements[i].pop('max_lat'), elements[i].pop('max_lng')
            ]
        
        elem['bounds'] = elem_bounds
        elem['center'] = {
            'lat': elem.pop('lat') or None,
            'lng': elem.pop('lng') or None
        }

    return JsonResponse({
        'status': 200,
        'body': elements
    })

def lookup_map(req):
    map_id = req.GET.get('map_id', 0)
    if map_id == 0:
        parent_map_id = req.GET.get('parent_map', 0)
        parent_elem_id = req.GET.get('parent_element', None)
        if parent_elem_id is None:
            return JsonResponse({
                'status': 400,
                'body': 'Incomplete parameters in request.'
            })
        
        try:
            parent_elem_id = str(parent_elem_id).upper()
            parent_map_id = int(parent_map_id)
            if parent_map_id < 0:
                raise Exception('Parent map ID cannot be negative.')
        except:
            return JsonResponse({
                'status': 400,
                'body': 'Invalid parent map ID.'
            })
        
        child_maps = execute_query(
            f'SELECT id AS map_id, level FROM Map WHERE parent_element_id = "{parent_elem_id}" AND ' +
            f'parent_map_id {"IS NULL" if (parent_map_id == 0) else f"= {parent_map_id}"} ORDER BY level;'
        )
    else:
        parent_map = execute_query(
            'SELECT parent_map_id AS id, parent_element_id as element_id FROM Map WHERE ' +
            f'id = {map_id} LIMIT 1;'
        )
        if parent_map is None:
            return JsonResponse({
                'status': 404,
                'body': 'Indoor map not supported in this location.'
            })

        parent_map = parent_map[0]
        if parent_map["id"] is None:
            child_maps = execute_query(
                f'SELECT id AS map_id, level FROM Map WHERE parent_element_id = "{parent_map["element_id"]}" ' +
                f'AND parent_map_id IS NULL ORDER BY level;'
            )
        else:
            child_maps = execute_query(
                f'SELECT id AS map_id, level FROM Map WHERE parent_element_id = "{parent_map["element_id"]}" ' +
                f'AND parent_map_id = {parent_map["id"]} ORDER BY level;'
            )

    if child_maps is None:
        return JsonResponse({
            'status': 404,
            'body': 'Indoor map not supported in this location.'
        })
    
    return JsonResponse({
        'status': 200,
        'body': child_maps
    })

def lookup(req):
    elem_ids = req.GET.get('element_ids', None)
    if not elem_ids:
        return JsonResponse({
            'status': 400,
            'body': 'Invalid element request.'
        })
    
    elem_ids = str(elem_ids).upper()
    elem_ids = elem_ids.split(',')
    total_elements = len(elem_ids)
    if total_elements < 1:
        return JsonResponse({
            'status': 400,
            'body': 'Invalid element IDs parameter.'
        })
    
    try:
        with_geom = bool(int(req.GET.get("geom", 0)))
        elements = get_elements(elem_ids, with_geom)
    except Exception as error:
        print(repr(error))
        return JsonResponse({
            'status': 500,
            'body': 'Unexpected error found.'
        })

    return JsonResponse({
        'status': 200,
        'body': elements
    })

#TODO: fix map tiles folder
# TODO: create route recommendation api
def routes(req):
    start_map = req.GET.get('start_map')
    start_pos = str(req.GET.get('start_pos'))
    start_pos = start_pos.split(',')

    goal = req.GET.get('start')

def get_elements(elem_ids:list, with_geom:bool, for_relation:bool=False, relation_id:int=0):
    total_elements = len(elem_ids)

    if total_elements < 1:
        raise Exception({
            'status': 400,
            'body': 'Invalid element IDs parameter.'
        })
    
    nodes = []
    ways = []
    relations = []

    i = 0
    while i < total_elements:
        id = elem_ids[i]
        if len(id) < 2:
            elem_ids.pop(i)
            total_elements - 1
            continue

        type = id[0]
        try:
            if type == 'N':
                nodes.append(int(id[1:]))
            elif type == 'W':
                ways.append(id[1:])
            elif type == 'R':
                relations.append(id[1:])
            else:
                elem_ids.pop(i)
                total_elements - 1
                continue
        except:
            raise Exception({
                'status': 400,
                'body': 'Invalid element ID found.',
            })
        
        i += 1
    
    elements = []
    if nodes:
        elements += get_nodes(nodes, with_geom, for_relation, relation_id)
    
    if ways:
        elements += get_ways(ways, with_geom, for_relation, relation_id)
    
    if relations:
        elements += get_relations(relations, with_geom, for_relation, relation_id)

    return elements

def get_nodes(ids:list[str], with_geom:bool, for_relation:bool=False, relation_id:int=0):
    if for_relation and with_geom:
        nodes = execute_query(
            'SELECT "node" AS type, n.id, n.lat, n.lng, rm.role FROM RelationMember rm INNER JOIN Node n ON ' +
            f'rm.element_id = CONCAT("N", wnid) WHERE n.id IN ({", ".join(ids)}) AND rm.relation_id = {relation_id};'
        ) or []
        return nodes
    elif for_relation:
        nodes = execute_query(
            'SELECT "node" AS type, n.id, rm.role FROM RelationMember rm INNER JOIN Node n ON ' +
            f'rm.element_id = CONCAT("N", wnid) WHERE n.id IN ({", ".join(ids)}) AND rm.relation_id = {relation_id};'
        ) or []
        return nodes
    
    nodes = execute_query(
        'SELECT "node" AS type, n.id, e.map_id, n.lat, n.lng, e.tags FROM Element e INNER JOIN Node n ON ' +
        f'e.id = CONCAT("N", n.id) WHERE n.id IN ({", ".join(ids)});'
    )
    if nodes is None:
        return []
    
    for i in range(len(nodes)):
        node = nodes[i]
        nodes[i]['bounds'] = [node['lat'], node['lng'], node['lat'], node['lng']]
        nodes[i]['center'] = {
            'lat': nodes[i].pop('lat'),
            'lng': nodes[i].pop('lng')
        }
        nodes[i]['tags'] = json.loads(f'{{{node["tags"]}}}' or '{}')
    
    return nodes

def get_ways(ids:list[str], with_geom:bool, for_relation:bool=False, relation_id:int=0):
    if for_relation:
        ways = execute_query(
            'SELECT "way" AS type, id, role FROM RelationMember rm INNER JOIN Way w ON ' +
            f'rm.element_id = CONCAT("W", w.id) WHERE w.id IN ({", ".join(ids)}) AND rm.relation_id = {relation_id};'
        )
        if not with_geom:
            return ways
    else:
        ways = execute_query(
            'SELECT "way" AS type, w.id, e.map_id, w.lat, w.lng, e.tags, w.min_lat, w.min_lng, w.max_lat, ' +
            'w.max_lng FROM Element e INNER JOIN Way w ON e.id = CONCAT("W", w.id) ' 
            f'WHERE w.id IN ({", ".join(ids)});'
        )
    
    if ways is None:
        return []
    
    if for_relation and with_geom:
        way_points = execute_query(
            'SELECT wp.way_id, n.lat, n.lng FROM Waypoint wp INNER JOIN Node n ON wp.node_id = n.id ' +
            f'WHERE wp.way_id IN ({", ".join(ids)}) ORDER BY wp.way_id, wp.sequence;'
        )
    elif with_geom:
        way_points = execute_query(
            'SELECT wp.way_id, n.id, n.lat, n.lng FROM Waypoint wp INNER JOIN Node n ON wp.node_id = n.id ' +
            f'WHERE wp.way_id IN ({", ".join(ids)}) ORDER BY wp.way_id, wp.sequence;'
        )
    else:
        way_points = execute_query(
            'SELECT wp.way_id, n.id FROM Waypoint wp INNER JOIN Node n ON wp.node_id = n.id ' +
            f'WHERE wp.way_id IN ({", ".join(ids)}) ORDER BY wp.way_id, wp.sequence;'
        )
    
    for i in range(len(ways)):
        way = ways[i]
        points = [point for point in way_points if point['way_id'] == way['id']]

        if with_geom or for_relation:
            ways[i]['geom'] = [{key: point[key] for key in ['lat', 'lng']} for point in points]
        
        if not for_relation:
            ways[i]['nodes'] = [point['id'] for point in points]
            ways[i]['bounds'] = [
                ways[i].pop('min_lat'), ways[i].pop('min_lng'),
                ways[i].pop('max_lat'), ways[i].pop('max_lng')
            ]
            ways[i]['center'] = {
                'lat': ways[i].pop('lat'),
                'lng': ways[i].pop('lng')
            }
            ways[i]['tags'] = json.loads(f'{{{way["tags"]}}}' or '{}')

    return ways

def get_relations(ids:list[str], with_geom:bool, for_relation:bool=False, relation_id:int=0):
    if for_relation and with_geom:
        relations = execute_query(
            'SELECT "relation" AS type, r.id, r.min_lat, r.min_lng, r.max_lat, r.max_lng, rm.role FROM ' +
            'RelationMember rm INNER JOIN Relation r ON rm.element_id = CONCAT("R", r.id) ' +
            f'WHERE r.id IN ({", ".join(ids)});'
        )
    elif for_relation:
        relations = execute_query(
            'SELECT "relation" AS type, r.id, rm.role FROM RelationMember rm INNER JOIN Relation r ON ' +
            f'rm.element_id = CONCAT("R", r.id) WHERE r.id IN ({", ".join(ids)}) AND rm.relation_id = {relation_id};'
        )
        return relations
    else:
        relations = execute_query(
            'SELECT "relation" AS type, r.id, e.map_id, r.lat, r.lng, e.tags, r.min_lat, r.min_lng, r.max_lat, ' +
            'r.max_lng FROM Element e INNER JOIN Relation r ON e.id = CONCAT("R", r.id) ' +
            f'WHERE r.id IN ({", ".join(ids)}) AND e.tags LIKE "%amenity%";'
        )
    
    if relations is None:
        return []

    members = execute_query(
        f'SELECT relation_id, element_id AS id FROM RelationMember WHERE relation_id IN ({", ".join(ids)}) ' +
        'ORDER BY relation_id;'
    ) or []

    for i in range(len(relations)):
        relation = relations[i]
        member_ids = [member['id'] for member in members if members['relation_id'] == relation['id']]
        
        relations[i]['bounds'] = [
            relations[i].pop('min_lat'), relations[i].pop('min_lng'),
            relations[i].pop('max_lat'), relations[i].pop('max_lng')
        ]
        if for_relation and with_geom:
            continue

        relations[i]['members'] = get_elements(member_ids, with_geom, True)
        relations[i]['center'] = {
            'lat': relations[i].pop('lat'),
            'lng': relations[i].pop('lng')
        }
        relations[i]['tags'] = json.loads(f'{{{relation["tags"]}}}' or '{}')
    
    return relations