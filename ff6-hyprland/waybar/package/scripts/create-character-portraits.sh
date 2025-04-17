#!/bin/bash
# FF6-themed Waybar Character Portraits Script
# This script creates a directory for character portraits and generates HTML for waybar modules

# Create directories
mkdir -p ~/.config/hyprland-crimson-config/waybar/portraits
mkdir -p ~/.config/hyprland-crimson-config/waybar/modules

# Copy character portraits from the sprites directory
cp -f /home/ubuntu/hyprland-crimson-config/sprites/terra.png ~/.config/hyprland-crimson-config/waybar/portraits/
cp -f /home/ubuntu/hyprland-crimson-config/sprites/locke.png ~/.config/hyprland-crimson-config/waybar/portraits/gannon.png
cp -f /home/ubuntu/hyprland-crimson-config/sprites/edgar.png ~/.config/hyprland-crimson-config/waybar/portraits/

# Create HTML files for character portraits with system information
cat > ~/.config/hyprland-crimson-config/waybar/modules/terra-portrait.html << EOF
<div class="character-portrait">
  <img src="~/.config/hyprland-crimson-config/waybar/portraits/terra.png" alt="Terra" width="48" height="48"/>
  <div class="character-info">
    <div class="name">Terra</div>
    <div class="stats">
      <div class="stat"><span class="label">LV</span> <span class="value" id="cpu-level">0</span></div>
      <div class="stat"><span class="label">HP</span> <span class="value" id="memory-used">0</span>/<span id="memory-total">0</span></div>
      <div class="stat"><span class="label">MP</span> <span class="value" id="disk-used">0</span>/<span id="disk-total">0</span></div>
    </div>
  </div>
</div>
<script>
  // Update CPU level (1-99 based on CPU usage)
  function updateCpuLevel() {
    fetch('http://localhost:9000/cpu')
      .then(response => response.json())
      .then(data => {
        const level = Math.max(1, Math.min(99, Math.floor(data.usage)));
        document.getElementById('cpu-level').textContent = level;
      })
      .catch(error => console.error('Error fetching CPU data:', error));
  }
  
  // Update memory stats
  function updateMemory() {
    fetch('http://localhost:9000/memory')
      .then(response => response.json())
      .then(data => {
        document.getElementById('memory-used').textContent = Math.floor(data.used);
        document.getElementById('memory-total').textContent = Math.floor(data.total);
      })
      .catch(error => console.error('Error fetching memory data:', error));
  }
  
  // Update disk stats
  function updateDisk() {
    fetch('http://localhost:9000/disk')
      .then(response => response.json())
      .then(data => {
        document.getElementById('disk-used').textContent = Math.floor(data.used);
        document.getElementById('disk-total').textContent = Math.floor(data.total);
      })
      .catch(error => console.error('Error fetching disk data:', error));
  }
  
  // Update all stats every 5 seconds
  setInterval(() => {
    updateCpuLevel();
    updateMemory();
    updateDisk();
  }, 5000);
  
  // Initial update
  updateCpuLevel();
  updateMemory();
  updateDisk();
</script>
EOF

cat > ~/.config/hyprland-crimson-config/waybar/modules/gannon-portrait.html << EOF
<div class="character-portrait">
  <img src="~/.config/hyprland-crimson-config/waybar/portraits/gannon.png" alt="Gannon" width="48" height="48"/>
  <div class="character-info">
    <div class="name">Gannon</div>
    <div class="stats">
      <div class="stat"><span class="label">LV</span> <span class="value" id="network-level">0</span></div>
      <div class="stat"><span class="label">HP</span> <span class="value" id="temperature">0</span>/<span id="temperature-max">100</span></div>
    </div>
  </div>
</div>
<script>
  // Update network level (1-99 based on network activity)
  function updateNetworkLevel() {
    fetch('http://localhost:9000/network')
      .then(response => response.json())
      .then(data => {
        // Calculate level based on network activity (simplified)
        const level = Math.max(1, Math.min(99, Math.floor(data.activity * 100)));
        document.getElementById('network-level').textContent = level;
      })
      .catch(error => console.error('Error fetching network data:', error));
  }
  
  // Update temperature
  function updateTemperature() {
    fetch('http://localhost:9000/temperature')
      .then(response => response.json())
      .then(data => {
        document.getElementById('temperature').textContent = Math.floor(data.temperature);
      })
      .catch(error => console.error('Error fetching temperature data:', error));
  }
  
  // Update all stats every 5 seconds
  setInterval(() => {
    updateNetworkLevel();
    updateTemperature();
  }, 5000);
  
  // Initial update
  updateNetworkLevel();
  updateTemperature();
</script>
EOF

cat > ~/.config/hyprland-crimson-config/waybar/modules/edgar-portrait.html << EOF
<div class="character-portrait">
  <img src="~/.config/hyprland-crimson-config/waybar/portraits/edgar.png" alt="Edgar" width="48" height="48"/>
  <div class="character-info">
    <div class="name">Edgar</div>
    <div class="stats">
      <div class="stat"><span class="label">LV</span> <span class="value" id="workspace-level">0</span></div>
      <div class="stat"><span class="label">HP</span> <span class="value" id="battery-level">0</span>/<span id="battery-max">100</span></div>
    </div>
  </div>
</div>
<script>
  // Update workspace level (based on active workspace)
  function updateWorkspaceLevel() {
    fetch('http://localhost:9000/workspace')
      .then(response => response.json())
      .then(data => {
        document.getElementById('workspace-level').textContent = data.active;
      })
      .catch(error => console.error('Error fetching workspace data:', error));
  }
  
  // Update battery level
  function updateBatteryLevel() {
    fetch('http://localhost:9000/battery')
      .then(response => response.json())
      .then(data => {
        document.getElementById('battery-level').textContent = Math.floor(data.percentage);
      })
      .catch(error => console.error('Error fetching battery data:', error));
  }
  
  // Update all stats every 5 seconds
  setInterval(() => {
    updateWorkspaceLevel();
    updateBatteryLevel();
  }, 5000);
  
  // Initial update
  updateWorkspaceLevel();
  updateBatteryLevel();
</script>
EOF

# Create a simple API server script to provide system information
cat > ~/.config/hyprland-crimson-config/waybar/modules/system-api-server.py << EOF
#!/usr/bin/env python3
import http.server
import socketserver
import json
import psutil
import os
import subprocess
import threading
import time

PORT = 9000

# Cache for system data
cache = {
    'cpu': {'usage': 0},
    'memory': {'used': 0, 'total': 0},
    'disk': {'used': 0, 'total': 0},
    'network': {'activity': 0},
    'temperature': {'temperature': 0},
    'workspace': {'active': 1},
    'battery': {'percentage': 100}
}

# Update system data in background
def update_system_data():
    while True:
        try:
            # CPU usage
            cache['cpu']['usage'] = psutil.cpu_percent()
            
            # Memory usage
            mem = psutil.virtual_memory()
            cache['memory']['used'] = mem.used / (1024 * 1024 * 1024)  # GB
            cache['memory']['total'] = mem.total / (1024 * 1024 * 1024)  # GB
            
            # Disk usage
            disk = psutil.disk_usage('/')
            cache['disk']['used'] = disk.used / (1024 * 1024 * 1024)  # GB
            cache['disk']['total'] = disk.total / (1024 * 1024 * 1024)  # GB
            
            # Network activity (simplified)
            net_io = psutil.net_io_counters()
            cache['network']['activity'] = (net_io.bytes_sent + net_io.bytes_recv) / (1024 * 1024)  # MB
            
            # Temperature (simplified)
            if hasattr(psutil, "sensors_temperatures"):
                temps = psutil.sensors_temperatures()
                if temps and 'coretemp' in temps:
                    cache['temperature']['temperature'] = temps['coretemp'][0].current
            
            # Active workspace (using hyprctl)
            try:
                result = subprocess.run(['hyprctl', 'activeworkspace', '-j'], 
                                       capture_output=True, text=True, check=True)
                workspace_data = json.loads(result.stdout)
                cache['workspace']['active'] = workspace_data.get('id', 1)
            except:
                cache['workspace']['active'] = 1
            
            # Battery percentage
            if hasattr(psutil, "sensors_battery"):
                battery = psutil.sensors_battery()
                if battery:
                    cache['battery']['percentage'] = battery.percent
        except Exception as e:
            print(f"Error updating system data: {e}")
        
        time.sleep(2)  # Update every 2 seconds

# Start background thread for updating system data
update_thread = threading.Thread(target=update_system_data, daemon=True)
update_thread.start()

class SystemAPIHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        
        path = self.path.strip('/')
        
        if path in cache:
            self.wfile.write(json.dumps(cache[path]).encode())
        else:
            self.wfile.write(json.dumps({'error': 'Not found'}).encode())
    
    def log_message(self, format, *args):
        # Suppress log messages
        return

def run_server():
    with socketserver.TCPServer(("localhost", PORT), SystemAPIHandler) as httpd:
        print(f"Serving at port {PORT}")
        httpd.serve_forever()

if __name__ == "__main__":
    run_server()
EOF

# Make the API server executable
chmod +x ~/.config/hyprland-crimson-config/waybar/modules/system-api-server.py

# Create a script to launch the API server
cat > ~/.config/hyprland-crimson-config/waybar/modules/launch-api-server.sh << EOF
#!/bin/bash
# Check if the API server is already running
if pgrep -f "system-api-server.py" > /dev/null; then
    echo "API server is already running"
else
    echo "Starting API server"
    ~/.config/hyprland-crimson-config/waybar/modules/system-api-server.py &
fi
EOF

# Make the launch script executable
chmod +x ~/.config/hyprland-crimson-config/waybar/modules/launch-api-server.sh

# Create custom modules for the character portraits
cat > ~/.config/hyprland-crimson-config/waybar/modules/ff6-portraits.jsonc << EOF
{
    "custom/terra_portrait": {
        "format": "{}",
        "return-type": "json",
        "exec": "echo '{\"text\": \"<span>Terra</span>\", \"tooltip\": \"CPU, Memory, Disk\"}'",
        "on-click": "kitty",
        "interval": "once"
    },
    
    "custom/gannon_portrait": {
        "format": "{}",
        "return-type": "json",
        "exec": "echo '{\"text\": \"<span>Gannon</span>\", \"tooltip\": \"Network, Temperature\"}'",
        "on-click": "rofi -show drun",
        "interval": "once"
    },
    
    "custom/edgar_portrait": {
        "format": "{}",
        "return-type": "json",
        "exec": "echo '{\"text\": \"<span>Edgar</span>\", \"tooltip\": \"Workspaces, Battery\"}'",
        "on-click": "thunar",
        "interval": "once"
    }
}
EOF

echo "Character portrait modules have been created successfully!"
