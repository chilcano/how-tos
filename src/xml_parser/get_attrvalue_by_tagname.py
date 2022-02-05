import xml.etree.ElementTree as ET
import sys, getopt
import re

def getAttrValueByTagName(argv): 
    xml_file = ""
    tag_name = ""
    attr_name = ""
    attr_value = ""
    try:
        opts, args = getopt.getopt(argv, "hx:t:n:v:", ["xmlFile=","tagName=","attrName=","attrValue="])
    except getopt.GetoptError:
        print("get_attrvalue_by_tagname.py -x <XmlFile> -t <TagName> -n <AttrName> -v <AttrValue>")
        sys.exit(2)
    for opt, arg in opts:
        if opt == "-h":
            print("get_attrvalue_by_tagname.py -x <XmlFile> -t <TagName> -n <AttrName> -v <AttrValue>")
            sys.exit()
        elif opt in ("-x", "--xmlFile"):
            xml_file = arg
        elif opt in ("-t", "--tagName"):
            tag_name = arg
        elif opt in ("-n", "--attrName"):
            attr_name = arg
        elif opt in ("-v", "--attrValue"):
            attr_value = arg

    myroot = ET.parse(xml_file).getroot()
    root_tag_regex = re.search("(\\{.+\\})(.*)", myroot.tag)
    ns = root_tag_regex.group(1)
    return_value = ""
    for child in myroot.iter(ns + tag_name):
        print(" -> " + child.tag, ": " + child.text)
        for attribute in child.attrib:
            aname = attribute
            avalue = child.get(aname)
            print("\t * " + aname, ": " + avalue)
            if (aname == attr_name) and (avalue.lower() == attr_value.lower()):
                return_value = avalue
                print("\t ** " + aname + "=" + avalue + " -> found !!!")
    return return_value    

if __name__ == "__main__":
    print("\n => " + getAttrValueByTagName(sys.argv[1:]) + " <= ")

    #end_value = getAttrValueByTagName("sample.xml", "food", "color", "yellow")
    #print("\n ==>> " + end_value + " <<== \n" )
    # python3 get_attrvalue_by_tagname.py -x sample.xml -t food -n color -v yellow