# Check Ping Shutdown (CPS) Service
This service will gracefully shutdown your host when it's unable to `ping` another host.

The configuration file is at `/etc/check-ping-shutdown.conf`, and then restart the `check-ping-shudown` service with:
```bash
sudo systemctl restart check-ping-shutdown
```
