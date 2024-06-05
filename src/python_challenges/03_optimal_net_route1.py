# dijkstra
# https://www.youtube.com/watch?v=yGtrFqiSn9o

import heapq

def dijkstra(graph, start_node, end_node):
    # Initialize distances with infinity
    distances = {node: float('inf') for node in graph}
    distances[start_node] = 0
    # Initialize the path tracker
    predecessor_nodes = {node: None for node in graph}

    # Initialize the priority queue
    priority_queue = [(0, start_node)]

    while priority_queue:
        # Pop the node with the smallest distance
        current_distance, current_node = heapq.heappop(priority_queue)

        # If we reach the end_node node, we can stop
        if current_node == end_node:
            break

        # Explore the neighbors
        for neighbor, weight in graph[current_node]:
            distance = current_distance + weight
            # If a shorter path to the neighbor is found
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                predecessor_nodes[neighbor] = current_node
                heapq.heappush(priority_queue, (distance, neighbor))

    # Reconstruct the shortest path
    path = []
    node = end_node
    while predecessor_nodes[node] is not None:
        path.insert(0, node)
        node = predecessor_nodes[node]
    if path:
        path.insert(0, start_node)
    
    return path, distances[end_node]

# Example usage
graph = {
    'A': [('B', 10), ('C', 20)],
    'B': [('D', 15)],
    'C': [('D', 30)],
    'D': []
}

start_node = 'A'
end_node = 'D'

shortest_path, shortest_distance = dijkstra(graph, start_node, end_node)
print(f"Shortest path from {start_node} to {end_node}: {shortest_path}")
print(f"Shortest distance from {start_node} to {end_node}: {shortest_distance}")
