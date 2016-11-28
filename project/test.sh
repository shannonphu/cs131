for i in "Alford" "Ball" "Welsh" "Holiday" "Hamilton"
do
  echo Starting $i
  python server.py $i &
done

echo "Started all servers"

sleep 2

{
	sleep 1
	echo IAMAT kiwi.cs.ucla.edu +34.068930-118.445127 1479413884.392014450
	sleep 1
} | telnet localhost 11581

{
	sleep 1
	echo IAMAT apple.cs.ucla.edu +34.068930-118.445127 1479413884.392014450
	sleep 1
} | telnet localhost 11581

{
	sleep 1
	echo IAMAT banana.cs.ucla.edu +34.068930-118.445127 1479413884.392014450
	sleep 1
} | telnet localhost 11582

{
	sleep 1
	echo WHATSAT banana.cs.ucla.edu 10 5
	sleep 1
} | telnet localhost 11581

pkill -f 'python server.py Alford'
pkill -f 'python server.py Holiday'
pkill -f 'python server.py Hamilton'
pkill -f 'python server.py Welsh'
pkill -f 'python server.py Ball'
