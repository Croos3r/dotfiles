#!/bin/bash

#zscroll -l 3  --delay 0.1 --scroll-padding "  " "cacacacacaca" & 2> /dev/null
#wait
zscroll -l 15 -u true -p " " -U 60 "`dirname $0`/crypto_status.sh" & 2> /dev/null
wait 
