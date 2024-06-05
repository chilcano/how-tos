import sys
import socket
from datetime import datetime
from typing import Dict

class PortScanner:
    def scan(self, ip: str, udp: bool, from_port: int, to_port: int) -> Dict[int, bool]:
        print("-" * 50)
        print("Scanning started at:" + str(datetime.now()))
        print("* IP: " + ip)
        print("* UDP: " + str(udp))
        print("* From port: " + str(from_port))
        print("* To port: " + str(to_port))
        print("-" * 50)
        mydict = {}
        str_open_port_list = ""
        try:
            target = socket.gethostbyname(ip)
            for port in range(from_port, to_port):
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                socket.setdefaulttimeout(1)
                result = s.connect_ex((target, port))
                if result == 0:
                    str_open_port_list += "- Port " + str(port) + " is open"
                    mydict[port] = True
                else:
                    mydict[port] = False
                s.close()
            if str_open_port_list == "":
                print("There aren't open ports")
            else:
                print(str_open_port_list)
            print("-" * 50)
            print(mydict)

        except KeyboardInterrupt:
                print("\n Exiting Program !!!!")
                sys.exit()
        except socket.gaierror:
                print("\n Hostname Could Not Be Resolved !!!!")
                sys.exit()
        except socket.error:
                print("\ Server not responding !!!!")
                sys.exit()


if len(sys.argv) == 5:
    ip_ = sys.argv[1]
    udp_ = bool(sys.argv[2])
    from_port_ = int(sys.argv[3])
    to_port_ = int(sys.argv[4])

    myscanner = PortScanner()
    myscanner.scan(ip_, bool(udp_), from_port_, to_port_)
else:
    print("Invalid number of arguments")

## Usage:
## python port_scanner.py 127.0.0.1 True 600 650
