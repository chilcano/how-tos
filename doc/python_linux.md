# Setup Python in Linux

Setup a Python environment on Ubuntu 20.04


```sh
echo ">> Installing Python3, Python3-Pip and Dev tools"

sudo apt -yqq install python3 python3-pip build-essential libssl-dev libffi-dev python3-dev python3-venv 

printf ">> $(python3 --version) installed.\n\n"
```
