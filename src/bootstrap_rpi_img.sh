#!/bin/bash

## References:
# https://hrushi-deshmukh.medium.com/getting-started-with-raspberry-pi-using-command-line-only-18aab667f183

## Examples:
# ./bootstrap_rpi_img.sh \
# --if=/media/roger/Transcend/isos-images/rpi/2021-10-30-raspios-bullseye-armhf.zip \
# --of=/dev/sdc \
# --ssh=enable
# --wifi=enable

unset _IF _OF _SSH _SSID 

while [ $# -gt 0 ]; do
  case "$1" in
    --if*|-i*)
      if [[ "$1" != *=* ]]; then shift; fi 
      _IF="${1#*=}"
      ;;
    --of*|-o*)
      if [[ "$1" != *=* ]]; then shift; fi 
      _OF="${1#*=}"
      ;;
    --ssh*|-s*)
      if [[ "$1" != *=* ]]; then shift; fi 
      _SSH="${1#*=}"
      ;;
    --wifi*|-w*)
      if [[ "$1" != *=* ]]; then shift; fi 
      _SSID="${1#*=}"
      ;;
    --help|-h)
      printf "Bootstrap OS Image on Raspberry Pi."
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument: '$1' \n"
      exit 1
      ;;
  esac
  shift
done

echo "##########################################################"
echo "#    Bootstrap OS Image on Raspberry Pi from Ubuntu      #"
echo "##########################################################"

sd_cards_list=$(lsblk --nodeps -n -o name -I8)
# sda
# sdb
# sdc

#sudo dd bs=1M if=/path/to/raspberrypi/image of=/dev/sdcardname status=progress conv=fsync
sudo dd bs=1M if=${_IF} of=${_OF} status=progress conv=fsync
echo "=> The ${_IF} copied into ${_OF} sucessfully."

path_boot_ubu="/media/${USER}/system-boot"
path_boot_rasp="/media/${USER}/boot"
path_boot=""

if [ -d "${path_boot_ubu}" ]; then
    path_boot="${path_boot_ubu}"
elif [ -d "${path_boot_rasp}" ]; then
    path_boot="${path_boot_rasp}"
else
    exit 1
fi

# Enable SSH
touch ${path_boot}/ssh
echo "=> SSH enabled on ${path_boot}/ssh"

# Enable and config WIFI
cat << EOF > wpa_supplicant.conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
#country=<Insert 2 letter ISO 3166-1 country code here>
country=ES

network={
    #ssid="<Name of your wireless LAN>"
    psk="<Password for your wireless LAN>"
    ssid="${_SSID}"
    psk="${_PSK}"
}
EOF
sudo chown -R root:root wpa_supplicant.conf
sudo mv -f wpa_supplicant.conf ${path_boot}/wpa_supplicant.conf
echo "=> WIFI enabled and configured on ${path_boot}/wpa_supplicant.conf"

echo "=> OS Image has been copied and configured. Now, You can plug your SD to your Raspberry Pi and boot it."
