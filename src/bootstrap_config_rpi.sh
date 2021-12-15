#!/bin/bash

## References:
# https://hrushi-deshmukh.medium.com/getting-started-with-raspberry-pi-using-command-line-only-18aab667f183
# https://en.wikipedia.org/wiki/ISO_3166-1

## Examples:
# ./bootstrap_rpi_img.sh \
# --if=/media/roger/Transcend/isos-images/rpi/2021-10-30-raspios-bullseye-armhf.img \
# --of=/dev/sdc \
# --wifi=enable

unset _IF _OF _WIFI _COUNTRY _SSID _PSK 

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
    --wifi*|-w*)
      if [[ "$1" != *=* ]]; then shift; fi 
      _WIFI="${1#*=}"
      ;;
    --help|-h)
      printf "Bootstrap OS Image on Raspberry Pi to be accessed remotelly."
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

# TODO: to be used to validate the source sd
sd_cards_list=$(lsblk --nodeps -n -o name -I8)
# sda
# sdb
# sdc

_COUNTRY="ES"
_SSID="test-ssid"
_PSK="test-pwd"

path_boot_ubu="/media/${USER}/system-boot"
path_boot_rasp="/media/${USER}/boot"
path_boot=""

if [ -z ${_WIFI+x} ]; then 
  echo "=> WIFI has not been enabled."
else 
  echo "=> WIFI has been enabled."
  _SSID=$(iwgetid -r)
  echo "=> The same WIFI (${_SSID}) LAN to which it is connected will be used."
  read -s -p "=> Enter the password to connect to WIFI (${_SSID}) LAN: " _PSK
  echo ""
fi

echo "=> We are ready to burn the Image in your SD Card. Continue (y/n)?: "
read _CONTINUE
if [ "${_CONTINUE}" != "y" ]; then
  echo "=> Process cancelled."
  return
fi

#sudo dd bs=1M if=/path/to/raspberrypi/image of=/dev/sdcardname status=progress conv=fsync
sudo dd bs=1M if=${_IF} of=${_OF} status=progress conv=fsync
echo "=> The ${_IF} copied into ${_OF} sucessfully."

if [ -d "${path_boot_ubu}" ]; then
  path_boot="${path_boot_ubu}"
elif [ -d "${path_boot_rasp}" ]; then
  path_boot="${path_boot_rasp}"
else
  printf "=> Error: Invalid Path to Boot partition in SD Card. \n"
  exit 1
fi

# Enable SSH
touch ${path_boot}/ssh
echo "=> SSH enabled on ${path_boot}/ssh"

# Enable and config WIFI
if [ -d "${path_boot_ubu}" ]; then
  ## Ubuntu
  echo "wifis:" | tee -a ${path_boot}/network-config >/dev/null
  echo "  wlan0:" | tee -a ${path_boot}/network-config >/dev/null
  echo "    dhcp4: true" | tee -a ${path_boot}/network-config >/dev/null
  echo "    optional: true" | tee -a ${path_boot}/network-config >/dev/null
  echo "    access-points:" | tee -a ${path_boot}/network-config >/dev/null
  echo "      '${_SSID}':" | tee -a ${path_boot}/network-config >/dev/null
  echo "        password: '${_PSK}'" | tee -a ${path_boot}/network-config >/dev/null
  echo "=> WIFI enabled and configured on ${path_boot}/network-config"
elif [ -d "${path_boot_rasp}" ]; then
  ## Raspbian, RPi OS
  echo "=> WIFI in Raspbian or RPi OS require Country code. Insert 2 letters ISO 3166-1 Country code here (i.e. ES, GB, US, ...): "
  read _COUNTRY
  echo ""
  echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "country=${_COUNTRY}" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "update_config=1" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "network={" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "  ssid='${_SSID}'" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "  psk='${_PSK}'" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "  proto=RSN" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "  key_mgmt=WPA-PSK" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "  pairwise=CCMP" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "  auth_alg=OPEN" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "}" | tee -a ${path_boot}/wpa_supplicant.conf >/dev/null
  echo "=> WIFI enabled and configured on ${path_boot}/wpa_supplicant.conf"
fi

echo "=> OS Image has been copied and configured. Now, You can plug your SD to your Raspberry Pi and boot it."
