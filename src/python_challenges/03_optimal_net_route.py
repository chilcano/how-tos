def dijkstra(graph, source, target, compression_nodes=None):
    if compression_nodes is None:
        compression_nodes = []

    latencies = {node: float('inf') for node in graph}
    latencies[source] = 0
    predecessor_nodes = {node: None for node in graph}
    unvisited_nodes = set(graph.keys())

    while unvisited_nodes:
        current_node = min(unvisited_nodes, key=lambda node: latencies[node])
        if current_node == target or latencies[current_node] == float('inf'):
            break
        
        for neighbor, weight in graph[current_node]:
            if current_node in compression_nodes:
                weight /= 2
            latency = latencies[current_node] + weight
            if latency < latencies[neighbor]:
                latencies[neighbor] = latency
                predecessor_nodes[neighbor] = current_node
        
        unvisited_nodes.remove(current_node)

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
graph2 = {
    'A': [('B', 10), ('C', 20), ('X', 8)],
    'B': [('D', 36), ('C', 2)],
    'C': [('D', 30)],
    'D': [],
    'X': [('C', 2), ('C', 20)]
}
source = 'A'
target = 'D'
compression_nodes = ['B', 'C']

final_path, min_total_latency = dijkstra(graph, source, target, compression_nodes)
print(f"Lowest latency path from {source} to {target}: {final_path}")
print(f"Minimum total latency: {min_total_latency}")
