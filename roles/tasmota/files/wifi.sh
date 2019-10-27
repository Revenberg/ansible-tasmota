#!/bin/bash
rm ~/ESSID_*.txt 2>/dev/null
echo "Pres CTRL+C to stop..."
while [ 1 ]; do
  iwlist wlan0 scan | grep ESSID | cut -d'"' -f 2

  ESSID=$(iwlist wlan0 scan | grep ITEAD | cut -d'"' -f 2)
  if [ "$ESSID" != "" ]; then
    echo $ESSID > $4
    if [ -f "~/ESSID_$ESSID.txt" ]; then
      sudo nmcli device wifi con "$ESSID" password "12345678" > $4
      "python3 /home/pi/SonOTA-master/SonOTA.py --serving-host $1 --wifi-ssid $2 --wifi-password $3 > $4"
      rm ~/ESSID_*.txt  2>/dev/null
      date > ~/ESSID_$ESSID.txt
    fi
  fi

  ESSID=$(iwlist wlan0 scan | grep FinalStage | cut -d'"' -f 2)
  if [ "$ESSID" == "FinalStage" ]; then
    echo $ESSID > $4
    if [ -f "~/ESSID_FinalStage.txt" ]; then
      sudo nmcli device wifi con "FinalStage" > $4
      rm ~/ESSID_*.txt 2>/dev/null
      date > ~/ESSID_FinalStage.txt
    fi
  fi
  sleep 1

  date > $4
done
