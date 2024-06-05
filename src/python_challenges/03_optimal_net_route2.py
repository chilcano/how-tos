def dijkstra(graph, source, target):
    # Initialize distances with infinity
    distances = {node: float('inf') for node in graph}
    distances[source] = 0
    # Initialize the path tracker
    predecessor_nodes = {node: None for node in graph}
    # Initialize the set of unvisited nodes
    unvisited_nodes = set(graph.keys())

    while unvisited_nodes:
        # Find the unvisited node with the smallest distance
        current_node = min(unvisited_nodes, key=lambda node: distances[node])
        
        # If we reach the target node or if the smallest distance is infinity, we can stop
        if current_node == target or distances[current_node] == float('inf'):
            break
        
        # Explore the neighbors
        for neighbor, weight in graph[current_node]:
            distance = distances[current_node] + weight
            # If a shorter path to the neighbor is found
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                predecessor_nodes[neighbor] = current_node
        
        # Mark the current node as visited
        unvisited_nodes.remove(current_node)

    # Reconstruct the shortest path
    path = []
    node = target
    while predecessor_nodes[node] is not None:
        path.insert(0, node)
        node = predecessor_nodes[node]
    if path:
        path.insert(0, source)
    
    return path, distances[target]

# Example usage
graph = {
    'A': [('B', 10), ('C', 20)],
    'B': [('D', 15)],
    'C': [('D', 30)],
    'D': []
}

source = 'A'
target = 'D'

shortest_path, shortest_distance = dijkstra(graph, source, target)
print(f"Lowest latency path from {source} to {target}: {shortest_path}")
print(f"Lowest latency value from {source} to {target}: {shortest_distance}")
