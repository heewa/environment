#!/bin/bash -e
sudo btrfs qgroup show --mbytes / | awk '{print} FNR>2 {R=R+$2; E=E+$3} END {print ""; print "total: ", R, E; print "avg: ", R/NR, E/NR}'
