def distribute_fragments(datacenter_risks, total_fragments):
    sorted_datacenter_risks = sorted(datacenter_risks.items(), key=lambda x: x[1], reverse=False)
    fragments_distribution = {key: 0 for key in datacenter_risks.keys()}
    
    for _ in range(total_fragments):
        min_risk_key = sorted_datacenter_risks[0][0]
        min_total_risk = (sorted_datacenter_risks[0][1] ** (fragments_distribution[min_risk_key] + 1))
        for key, risk in sorted_datacenter_risks:
            potential_risk = (risk ** (fragments_distribution[key] + 1))
            if potential_risk < min_total_risk:
                min_total_risk = potential_risk
                min_risk_key = key
        
        fragments_distribution[min_risk_key] += 1

    total_risk = sum(datacenter_risks[key] ** fragments_distribution[key] for key in fragments_distribution)

    return fragments_distribution, total_risk

# Initial values
TOTAL_NUMBER_FRAGMENTS = 5
DATACENTER_RISKS_DICT = {'dc2': 20, 'dc1': 10, 'dc3': 30}

distribution, total_min_risk = distribute_fragments(DATACENTER_RISKS_DICT, TOTAL_NUMBER_FRAGMENTS)

print(f"Initial Risks by Datacenter: {DATACENTER_RISKS_DICT}")
print(f"Final Distribution of Fragments: {distribution}")
print(f"Total minimized risk: {total_min_risk}")
