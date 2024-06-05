def dijkstra(graph, source, target, compression_nodes=None):
    if compression_nodes is None:
        compression_nodes = []

    # Initialize latencies with infinity
    latencies = {node: float('inf') for node in graph}
    latencies[source] = 0
    # Initialize the path tracker
    predecessor_nodes = {node: None for node in graph}
    # Initialize the set of unvisited nodes
    unvisited_nodes = set(graph.keys())

    while unvisited_nodes:
        # Find the unvisited node with the smallest latency
        current_node = min(unvisited_nodes, key=lambda node: latencies[node])
        
        # If we reach the target node or if the smallest latency is infinity, we can stop
        if current_node == target or latencies[current_node] == float('inf'):
            break
        
        # Explore the neighbors
        for neighbor, weight in graph[current_node]:
            # Apply compression if the current node is in compression_nodes
            if current_node in compression_nodes:
                weight /= 2
            latency = latencies[current_node] + weight
            # If a lower latency to the neighbor is found
            if latency < latencies[neighbor]:
                latencies[neighbor] = latency
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
    
    return path, latencies[target]

###### Values

graph = {
    'A': [('B', 10), ('C', 20)],
    'B': [('D', 15)],
    'C': [('D', 30)],
    'D': []
}
source = 'A'
target = 'D'
compression_nodes = ['B', 'C']

shortest_path, shortest_distance = dijkstra(graph, source, target, compression_nodes)
print(f"Lowest latency path from {source} to {target}: {shortest_path}")
print(f"Lowest latency value from {source} to {target}: {shortest_distance}")
