#!/bin/bash

URL="https://192.168.18.7:8080/status"

while true; do
    # Fetch the status from the URL
    RESPONSE=$(curl --silent --max-time 5 --insecure "$URL")

    # Check if the response contains {"mains":"up"}
    if [[ "$RESPONSE" == *'"mains":"up"'* ]]; then
        # Do nothing, continue checking
        sleep 0.5
        continue
    elif [[ "$RESPONSE" == *'"mains":"down"'* ]]; then
        # Shutdown the system if mains are down
        sudo shutdown -h now
        break
    else
        # If we cannot reach the endpoint or any other issue, shutdown
        sudo shutdown -h now
        break
    fi
done
