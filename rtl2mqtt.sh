#!/bin/bash

# A simple script that will receive events from a RTL433 SDR

# Author: Marco Verleun <marco@marcoach.nl>
# Version 2.0: Adapted for the new output format of rtl_433

/usr/local/bin/rtl_433 -F json | while read line
do

  DEVICE="$(echo $line | jq --raw-output '.model' | tr -s ' ' '_')" # replace ' ' with '_'
  DEVICEID="$(echo $line | jq --raw-output '.id' | tr -s ' ' '_')"

  MQTT_PATH=$MQTT_TOPIC/"$DEVICE"-"$DEVICEID"

  echo $line | /usr/bin/mosquitto_pub -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASS --id RTL_433 -r -t $MQTT_PATH/state -l

done
