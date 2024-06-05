def distribute_fragments(datacenter_risks, total_fragments):
    # Sort the datacenter risks in ascending order
    datacenter_risks_asc_sorted = sorted(datacenter_risks)
    
    # Initialize the count of fragments in each datacenter
    fragments_distribution = [0] * len(datacenter_risks)
    
    # Distribute the fragment
    for _ in range(total_fragments):
        min_risk_index = 0
        # Find the datacenter with the minimum risk after allocating a fragment
        min_total_risk = (datacenter_risks_asc_sorted[0] ** (fragments_distribution[0] + 1))
        for i in range(1, len(datacenter_risks_asc_sorted)):
            potential_risk = (datacenter_risks_asc_sorted[i] ** (fragments_distribution[i] + 1))
            if potential_risk < min_total_risk:
                min_total_risk = potential_risk
                min_risk_index = i
        
        # Allocate a fragment to the datacenter with the minimum increased risk
        fragments_distribution[min_risk_index] += 1

    # Calculate the total risk
    total_risk = sum(datacenter_risks_asc_sorted[i] ** fragments_distribution[i] for i in range(len(fragments_distribution)))
    
    return total_risk, fragments_distribution

# Example usage
TOTAL_NUMBER_FRAGMENTS = 5
DATACENTER_RISKS_LIST = [10, 20, 30]

total_min_risk, distribution_list = distribute_fragments(DATACENTER_RISKS_LIST, TOTAL_NUMBER_FRAGMENTS)

print(f"Distribution of fragments: {distribution_list}")
print(f"Total minimized risk: {total_min_risk}")
