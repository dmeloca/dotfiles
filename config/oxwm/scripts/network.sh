#!/usr/bin/env bash

nmcli -t -f TYPE,STATE,CONNECTION dev | awk -F: '$2=="connected"{print ($1=="wifi" ? $3 : "ethernet")}'
