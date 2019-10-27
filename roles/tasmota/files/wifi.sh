#!/bin/bash

set -e

ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

rm ~/ESSID_*.txt 2>/dev/null
echo "Pres CTRL+C to stop..."
while [ 1 ]; do
  iwlist wlan0 scan | grep ESSID | cut -d'"' -f 2

  ESSID=$(iwlist wlan0 scan | grep ITEAD | cut -d'"' -f 2)
  if [ "$ESSID" != "" ]; then
    echo $ESSID >> $3
    if [ -f "~/ESSID_$ESSID.txt" ]; then
      sudo nmcli device wifi con "$ESSID" password "12345678" >> $3
      python3 /home/pi/SonOTA-master/SonOTA.py --serving-host $ip --wifi-ssid $1 --wifi-password $2 >> $3
      rm ~/ESSID_*.txt  2>/dev/null
      date > ~/ESSID_$ESSID.txt
    fi
  fi

  ESSID=$(iwlist wlan0 scan | grep FinalStage | cut -d'"' -f 2)
  if [ "$ESSID" == "FinalStage" ]; then
    echo $ESSID >> $3
    if [ -f "~/ESSID_FinalStage.txt" ]; then
      sudo nmcli device wifi con "FinalStage" >> $3
      rm ~/ESSID_*.txt 2>/dev/null
      exit 0
    fi
  fi
  sleep 1

  date >> $3
done
