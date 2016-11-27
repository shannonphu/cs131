for i in "Alford" "Ball" "Welsh" "Holiday" "Hamilton"
do
  echo Starting $i
  python server.py $i &
done

echo "Started all servers"

sleep 2

{
	sleep 1
	echo IAMAT latte +37.322752-122.030836 1401072205.798801
	sleep 1
} | telnet localhost 13320

{
	sleep 1
	echo IAMAT coffee +34.151324-118.028232 1401496386.27158
	sleep 1
} | telnet localhost 13320

{
	sleep 1
	echo IAMAT nowhere +35-120 1401496586.27158
	sleep 1
} | telnet localhost 13322

{
	sleep 1
	echo WHATSAT latte 40 5
	sleep 1
} | telnet localhost 13320

pkill -f 'python server.py Alford'
pkill -f 'python server.py Holiday'
pkill -f 'python server.py Hamilton'
pkill -f 'python server.py Welsh'
pkill -f 'python server.py Ball'
