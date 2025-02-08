#!/bin/bash

CONFIG_FILE="/etc/check-ping-shutdown.conf"
failure=0

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

err() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $1"
		exit 1
}

shutdown_trigger() {
		if [[ "$DRY" == "FALSE" ]]; then
				log "Shutdown triggered, initiating a graceful shutdown..."
				sudo shutdown -h now
		elif [[ "$DRY" == "TRUE" ]]; then
				log "Shutdown triggered, exiting service as in dry mode..."
				exit 0
		fi
}

# Function to check if a variable matches allowed values
check_allowed_values() {
    local var_name="$1"
    local var_value="${!var_name}"
    shift
    local allowed_values=($@)
    for value in "${allowed_values[@]}"; do
        if [[ "$var_value" == "$value" ]]; then
            return 0
        fi
    done
    err "$var_name must be one of: ${allowed_values[*]}"
}

if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
		log "Config file found, checking required variables are present..."
		if [[ ! -z "$PING_SERVER" ]]; then
				log "Using PING_SERVER: $PING_SERVER"
		else
				err "PING_SERVER not defined!"
		fi

		# Ensure TIMEOUT is a whole number
    if ! [[ "$TIMEOUT" =~ ^[0-9]+$ ]]; then
        err "Error: TIMEOUT must be a whole number."
		else
				log "Using TIMEOUT=$TIMEOUT"
    fi

		# Check DRY (must be either FALSE or TRUE)
		check_allowed_values "DRY" "FALSE" "TRUE"

		# Check MODE (must be either ACTIVE or ALWAYS)
		check_allowed_values "MODE" "ACTIVE" "ALWAYS"
else
		err "No config found at /etc/check-ping-shutdown.conf!"
fi

while true; do
		# Change this ping timeout -W if you are not on physical LAN and have higher ping times
		if ping -c 1 -W 0.5 "$PING_SERVER" > /dev/null 2>&1; then
				failed_seconds=0
		else

				# When MODE is ALWAYS, we count down out TIMEOUT seconds before initiating a graceful shutdown
				if [[ "$MODE" == "ALWAYS" ]]; then
						log "Unable to ping $PING_SERVER, sleeping for $TIMEOUT seconds before gracefully shutting down..."
						sleep "$TIMEOUT"
						shutdown_trigger

				elif [[ "$MODE" == "ACTIVE" ]]; then
						((failed_seconds++))
						if [[ "$failed_seconds" -ge "$TIMEOUT" ]]; then
								shutdown_trigger
						fi
				fi
		fi

		# You can change this sleep to modify your ping interval
		sleep 1
done
