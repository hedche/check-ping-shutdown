# Check Ping Shutdown (CPS) Service
This service will gracefully shutdown your host when it's unable to `ping` another host.

### Install
```bash
wget -O /tmp/check-ping-shutdown-latest.deb "$(curl -s https://api.github.com/repos/hedche/check-ping-shutdown/releases/latest | grep "browser_download_url" | cut -d '"' -f 4)" && sudo dpkg -i /tmp/lcheck-ping-shutdown-latest.deb
```

### Configuration
```ini
# If PING_SERVER is down or unreachable, this will shutdown your appliance.
# It's better to use IP rather than hostname incase there is a DNS issue.
# e.g. PING_SERVER=192.168.1.5
PING_SERVER=

# TIMEOUT (in seconds) is the amount of time  will start counting down once PING_SERVER goes offline.
# i.e. how long do you anticipate your longest brownout to be. Don't set too high or your UPS might not have the juice for it.
TIMEOUT=60

# Two options for DRY:
# TRUE   - This will run the script/service in dry mode where shutdown commands are only logged.
# FALSE  - The service will actually shutdown this host. Set as default to inspect behaviour before usage.
DRY=TRUE

# There are two options for MODE:
# ACTIVE - As long as PING_SERVER comes back up before the timeout is reached the host will not shut itself down.
# ALWAYS - Will always shutdown your host after the timeout is reached. It doesn't care if PING_SERVER comes back up.
MODE=ACTIVE
```

The configuration file is isntalled at `/etc/check-ping-shutdown.conf`. After any changes, restart the `check-ping-shudown` service with:
```bash
sudo systemctl restart check-ping-shutdown
```
