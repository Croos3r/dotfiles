#!/bin/bash

zscroll -l 15 -d 0.1 -u true -p " " -U 60 "$(dirname "$0")/crypto_status.sh" &
2>/dev/null
wait
