#!/bin/bash

systemctl enable firewalld.service 
systemctl enable NetworkManager.service 
systemctl enable apparmor.service 
systemctl enable fstrim.timer 
systemctl enable systemd-timesyncd.service 
systemctl enable gdm.service 
