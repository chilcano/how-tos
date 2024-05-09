# import xml.etree.ElementTree as ET
from defusedxml.etree import ElementTree as ET
import sys, getopt
import re

def getTotalItemsMatchingCriteria(xml_file, tag_name, attr_name): 
    total_children = 0
    total_children_matches = 0
    total_children_matches_sum = 0

    root = ET.parse(xml_file).getroot()
    root_tag_regex = re.search("(\\{.+\\})(.*)", root.tag)
    ns = root_tag_regex.group(1)
    root_tag_name = root_tag_regex.group(2)
    children = root.findall(".//" + ns + tag_name)
    for item in children:
        print("\n -> " + item.tag + " : " )
        total_children = total_children + 1
        for attribute in item.attrib:
            aname = attribute
            avalue = item.get(aname)
            print("\t * " + aname, ": " + avalue)
            if ( aname == attr_name ) and ( int(avalue) > 0 ):
                total_children_matches = total_children_matches + 1
                total_children_matches_sum = total_children_matches_sum + int(avalue)

    return  str(total_children) + "/" + str(total_children_matches) + "/" + str(total_children_matches_sum)

if __name__ == "__main__":
    print("\n=> Total vulnerable components: " + getTotalItemsMatchingCriteria( sys.argv[1], sys.argv[2], sys.argv[3] ) )
    # python3 get_total_items_matching_criteria.py summaryreport.xml component vulnerabilities
