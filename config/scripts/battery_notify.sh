#!/usr/bin/env bash

BAT_PATH="/sys/class/power_supply/BAT0"

# Detect AC adapter path automatically
for CAND in AC AC0 ACAD ADP1; do
    if [[ -d "/sys/class/power_supply/$CAND" ]]; then
        AC_PATH="/sys/class/power_supply/$CAND"
        break
    fi
done

LEVEL=""
STATE=""

while true; do
    [[ ! -d "$BAT_PATH" ]] && sleep 60 && continue

    CAPACITY=$(<"$BAT_PATH/capacity")
    STATUS=$(<"$BAT_PATH/status")

    # If AC path exists, use it for charger connection detection
    if [[ -n "$AC_PATH" ]]; then
        AC_STATUS=$(<"$AC_PATH/online")
        # AC online = 1 means charging cable connected
        if [[ "$AC_STATUS" == "1" ]]; then
            NEW_STATE="Charging"
        else
            NEW_STATE="Discharging"
        fi
    else
        NEW_STATE="$STATUS"
    fi

    # Notify on state change (charger connect/disconnect)
    if [[ "$NEW_STATE" != "$STATE" ]]; then
        if [[ "$NEW_STATE" == "Charging" ]]; then
            notify-send -u low "Charger Connected" "Battery is charging (${CAPACITY}%)."
        else
            notify-send -u low "Charger Disconnected" "Running on battery (${CAPACITY}%)."
        fi
        STATE="$NEW_STATE"
    fi

    # Battery level notifications
    if [[ "$STATUS" == "Discharging" && "$CAPACITY" -le 15 && "$LEVEL" != "low" ]]; then
        notify-send -u critical "Battery Low" "Battery level is ${CAPACITY}%."
        LEVEL="low"

    elif [[ "$STATUS" == "Discharging" && "$CAPACITY" -le 5 && "$LEVEL" != "critical" ]]; then
        notify-send -u critical "Battery Critical" "Battery level is ${CAPACITY}%. Charge immediately."
        LEVEL="critical"

    elif [[ "$STATUS" == "Discharging" && "$CAPACITY" -le 3 ]]; then
        notify-send -u critical "Hibernating" "Battery almost empty. System will hibernate."
        systemctl hibernate

    elif [[ "$STATUS" =~ ^Charging|Full$ && "$CAPACITY" -ge 95 && "$LEVEL" != "full" ]]; then
        notify-send -u normal "Battery Full" "You can unplug the charger."
        LEVEL="full"
    fi

    sleep 60
done

