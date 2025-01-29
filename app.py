from flask import Flask, jsonify
import subprocess
import threading
import time

app = Flask(__name__)

# Global variable to store ping status
ping_status = {"mains": "down"}

def ping_host():
    while True:
        try:
            # Run ping command with a timeout of 1 second
            result = subprocess.run(
                ['ping', '-c', '1', '-W', '1', '192.168.18.5'],
                capture_output=True,
                text=True
            )
            ping_status["mains"] = "up" if result.returncode == 0 else "down"
        except Exception:
            ping_status["mains"] = "down"
        time.sleep(1)

@app.route('/status', methods=['GET'])
def get_status():
    return jsonify(ping_status)

if __name__ == '__main__':
    # Start ping thread
    ping_thread = threading.Thread(target=ping_host, daemon=True)
    ping_thread.start()
    
    # Start Flask app
    app.run(host='0.0.0.0', port=8080, ssl_context='adhoc')
