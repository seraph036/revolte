import os
import subprocess
from shello import shell

wifiRaw = shell.nmcli("-g", "ACTIVE", "SIGNAL", "FREQ", "SSID", "SECURITY", "d", "w").execute() #| shell.grep("-v", "::")).execute()

print(wifiRaw)
