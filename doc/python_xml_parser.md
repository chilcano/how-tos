# Python XML Parser samples

## Examples


### O) Preparation

```sh
python3 --version

Python 3.9.7
```

```sh
cd src/xml_parser/
```

### 1) xml_parser_simple.py 

```sh
$ python3 get_attrvalue_by_tagname.py -x sample.xml -t food -n color -v yellow

-> {https://holisticsecurity.io/schema/1.0/list}food : 
            
	 * color : yellow
	 ** color=yellow -> found !!!
	 * time : morning
 -> {https://holisticsecurity.io/schema/1.0/list}food : 
            
	 * color : orange
	 * time : evening
 -> {https://holisticsecurity.io/schema/1.0/list}food : 
            
	 * color : blue
	 * time : afternoon
 -> {https://holisticsecurity.io/schema/1.0/list}food : 
            
	 * color : red
	 * time : midnight
 -> {https://holisticsecurity.io/schema/1.0/list}food : 
            
	 * color : pink
	 * time : night

 => yellow <=
```

### 2) xml_parser_simple.py 

```sh
$ python3 get_total_items_matching_criteria.py summaryreport.xml component vulnerabilities

...
...
=> Total vulnerable components: 63/2/2
```

### 3) xml_parser_simple.py 

```sh
$ python3 get_total_items_matching_criteria2.py summaryreport.xml component vulnerabilities

-> {https://www.veracode.com/schema/reports/export/1.0}component : 
	 * component_affects_policy_compliance : false
	 * component_id : c6390188-9a15-498f-9d72-9a7f05697313
	 * description : 
	 * file_name : pyyaml
	 * library : PyYAML
	 * library_id : pypi:pyyaml::5.3.1:source
	 * max_cvss_score : 9.8
	 * sha1 : 
	 * vendor : 
	 * version : 5.3.1
	 * vulnerabilities : 1

 -> {https://www.veracode.com/schema/reports/export/1.0}component : 
	 * component_affects_policy_compliance : false
	 * component_id : e72dfd21-c324-42f2-ad0d-4c384406fe6f
	 * description : 
	 * file_name : urllib3
	 * library : urllib3
	 * library_id : pypi:urllib3::1.25.10:source
	 * max_cvss_score : 7.5
	 * sha1 : 
	 * vendor : 
	 * version : 1.25.10
	 * vulnerabilities : 1

=> Total vulnerable components: 2/2/2
```