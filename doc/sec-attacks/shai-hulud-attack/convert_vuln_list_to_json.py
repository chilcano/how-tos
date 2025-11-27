#!/usr/bin/env python3
import json
import sys
import os
import re
from datetime import date

# ---------------------------------------------------------
# Regex patterns
# ---------------------------------------------------------

LINE_REGEX = re.compile(r"^(.+?)\s*\((.*?)\)\s*$")

META_SOURCE_REGEX   = re.compile(r"^\s*#?\s*source\s*:\s*(.+)$", re.IGNORECASE)
META_CAMPAIGN_REGEX = re.compile(r"^\s*#?\s*campaign\s*:\s*(.+)$", re.IGNORECASE)


# ---------------------------------------------------------
# Usage helper
# ---------------------------------------------------------

def print_usage():
    print("Usage:")
    print("  python3 convert_vuln_list_to_json.py <vuln_list.txt> <output.json>")
    print("")
    print("Example:")
    print("  python3 convert_vuln_list_to_json.py vuln_list.txt vulns.json")
    print("")


# ---------------------------------------------------------
# Parse vuln text file
# ---------------------------------------------------------

def parse_vuln_file(path):
    if not os.path.exists(path):
        raise FileNotFoundError(f"Input file not found: {path}")

    packages = {}
    metadata = {
        "source": None,
        "campaign": None,
        "date": str(date.today())
    }

    with open(path, "r", encoding="utf-8") as f:
        for raw in f:
            line = raw.strip()

            if not line:
                continue

            # --- Metadata parsing ---
            src_match = META_SOURCE_REGEX.match(line)
            if src_match:
                metadata["source"] = src_match.group(1).strip()
                continue

            camp_match = META_CAMPAIGN_REGEX.match(line)
            if camp_match:
                metadata["campaign"] = camp_match.group(1).strip()
                continue

            # Skip comment-only lines
            if line.startswith("#"):
                continue

            # --- Package + versions parsing ---
            match = LINE_REGEX.match(line)
            if not match:
                continue

            pkg = match.group(1).strip()
            versions_raw = match.group(2)

            versions = []
            for v in versions_raw.split(","):
                versions.append(v.strip().replace("v", ""))

            packages[pkg] = versions

    return metadata, packages


# ---------------------------------------------------------
# Build final JSON structure
# ---------------------------------------------------------

def build_output(metadata, packages):
    if not metadata.get("source"):
        metadata["source"] = "N/A"
    if not metadata.get("campaign"):
        metadata["campaign"] = "N/A"

    return {
        "metadata": metadata,
        "packages": packages
    }


# ---------------------------------------------------------
# Main
# ---------------------------------------------------------

def main():
    if len(sys.argv) != 3:
        print("ERROR: incorrect number of arguments.\n")
        print_usage()
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]

    print(f"Reading vulnerable package list from: {input_path}")

    try:
        metadata, packages = parse_vuln_file(input_path)
    except Exception as e:
        print("ERROR while parsing input file:", e)
        sys.exit(1)

    # Count packages and versions
    unique = len(packages)
    total_vuln_versions = sum(len(v) for v in packages.values())

    print(f"Using {input_path} ({unique} unique packages, {total_vuln_versions} total vulnerable versions)")

    # Print extracted metadata
    print(f"Source:   {metadata.get('source', 'N/A')}")
    print(f"Campaign: {metadata.get('campaign', 'N/A')}")
    print(f"Date:     {metadata.get('date', 'N/A')}")

    final_json = build_output(metadata, packages)

    try:
        with open(output_path, "w", encoding="utf-8") as out:
            json.dump(final_json, out, indent=2)
    except Exception as e:
        print("ERROR writing output JSON:", e)
        sys.exit(1)

    print(f"Saved JSON to: {output_path}")


if __name__ == "__main__":
    main()
