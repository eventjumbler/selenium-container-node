# new order:

#java -D-Dwebdriver.firefox.bin="/usr/bin/firefox" -Dwebdriver.gecko.driver=/usr/local/lib/geckodriver -jar selenium-server-standalone-3.6.0.jar -role hub &

#sleep 0.5


export DISPLAY=:11
rm -f /tmp/.X11-lock
Xvfb :11 -screen 0 $SCREENSIZE &
sleep 0.5

java -D-Dwebdriver.firefox.bin="/usr/bin/firefox" -Dwebdriver.gecko.driver=/usr/local/lib/geckodriver -jar selenium-server-standalone-3.6.0.jar -role hub -timeout=30 -browserTimeout=600 &
java -jar selenium-server-standalone-3.6.0.jar -role node -hub http://localhost:4444/grid/register
exit


tcpdump dst port 5555 -tt > tcp.dump &


#old order:

#or should this be uncommented and the one below commented out?  java -D-Dwebdriver.firefox.bin="/usr/bin/firefox" -Dwebdriver.gecko.driver=/usr/local/lib/geckodriver -jar selenium-server-standalone-3.6.0.jar -role hub &
#sleep 0.5

export DISPLAY=:11
rm -f /tmp/.X11-lock
Xvfb :11 -screen 0 $SCREENSIZE &

java -Dwebdriver.firefox.bin="/usr/bin/firefox" -Dwebdriver.gecko.driver=/usr/local/lib/geckodriver -jar selenium-server-standalone-3.6.0.jar -role node -hub http://localhost:4444/grid/register

# old: java -jar selenium-server-standalone-3.6.0.jar -role node -hub http://localhost:4444/grid/register
