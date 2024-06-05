def distribute_fragments(datacenter_risks, total_fragments):
    # Convert the datacenter_risks dictionary to a list of tuples and sort by risk
    sorted_datacenter_risks = sorted(datacenter_risks.items(), key=lambda x: x[1], reverse=False)
    
    # Initialize the count of fragments in each datacenter
    fragments_distribution = {key: 0 for key in datacenter_risks.keys()}
    
    # Distribute the fragments
    for _ in range(total_fragments):
        min_risk_key = sorted_datacenter_risks[0][0]
        min_total_risk = (sorted_datacenter_risks[0][1] ** (fragments_distribution[min_risk_key] + 1))
        for key, risk in sorted_datacenter_risks:
            potential_risk = (risk ** (fragments_distribution[key] + 1))
            if potential_risk < min_total_risk:
                min_total_risk = potential_risk
                min_risk_key = key
        
        # Allocate an fragment to the datacenter with the minimum increased risk
        fragments_distribution[min_risk_key] += 1

    # Calculate the total risk
    total_cost = sum(datacenter_risks[key] ** fragments_distribution[key] for key in fragments_distribution)
    
    # Create a sorted dict
    sorted_datacenter_by_risk = {k: v for k, v in sorted_datacenter_risks}

    return fragments_distribution, total_cost, sorted_datacenter_by_risk

# Example usage
TOTAL_NUMBER_FRAGMENTS = 5
DATACENTER_RISKS_DICT = {'dc2': 20, 'dc1': 10, 'dc3': 30}

distribution, total_min_risk, sorted_datacenter_by_risk = distribute_fragments(DATACENTER_RISKS_DICT, TOTAL_NUMBER_FRAGMENTS)

print(f"Sorted Datacenter by risk: {sorted_datacenter_by_risk}")
print(f"Final distribution of fragments: {distribution}")
print(f"Total minimized risk: {total_min_risk}")
