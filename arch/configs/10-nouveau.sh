#!/bin/bash

case $1/$2 in
  pre/*)
    # echo "Going to $2..."
    /usr/bin/echo "0" > /sys/class/vtconsole/vtcon1/bind
    /usr/bin/rmmod nouveau
    ;;
  post/*)
    # echo "Waking up from $2..."
    /usr/bin/modprobe nouveau
    /usr/bin/echo "1" > /sys/class/vtconsole/vtcon1/bind
    ;;
esac
