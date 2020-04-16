VAR="1.14.3"

function ver1 { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }


function ver2 { printf "%03d%03d%03d%03d" $(echo "$1" | tr '.' ' '); }


ver3 (){ printf "%03d%03d%03d%03d" $(echo "$1" | tr '.' ' '); }


if [ $(ver1 "1.15.4") -le $(ver1 ${VAR}) ]; then
    echo "1.15.4 <=  ${VAR}"
else
    echo "1.15.4 > ${VAR}"
fi


if [ $(ver2 1.15.4) -le $(ver2 ${VAR}) ]; then
    echo "1.15.4 <=  ${VAR}"
else
    echo "1.15.4 > ${VAR}"
fi


if [ $(ver3 "1.15.4") -le $(ver3 ${VAR}) ]; then
    echo "1.15.4 <=  ${VAR}"
else
    echo "1.15.4 > ${VAR}"
fi


echo "--->v1: $(ver1 ${VAR}) , v2: $(ver2 ${VAR})"
echo "--->v1: $(ver1 1.15.4) , v2: $(ver2 1.15.4)"


