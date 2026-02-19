nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev status | awk -F: '
$2=="ethernet" && $3=="connected" { print "Ethernet"; found=1 }
$2=="wifi" && $3=="connected" { print $4; found=1 }
END { if (!found) print "Disconnected" }
'

