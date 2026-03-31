#yes:80:2412 MHz:Alexandre:WPA2 WPA3
#no:47:2417 MHz:HUAWEI-2.4G-558i:WPA1 WPA2
#no:40:2437 MHz:Galvao:WPA1 WPA2
#no:40:5765 MHz:Galvao 5.0:WPA1 WPA2
#no:30:2412 MHz:Nilson:WPA1 WPA2
#no:27:2462 MHz:AGI:WPA2
#no:24:2412 MHz:VIVOFIBRA-WIFI6-8891:WPA2
#no:20:2427 MHz:Camomila:WPA2
#no:20:2462 MHz:NADIA:WPA1 WPA2

nmcli -g ACTIVE,SIGNAL,FREQ,SSID,SECURITY d w | grep -v :: |

while IFS= read -r line; do
    echo "$line"
done
