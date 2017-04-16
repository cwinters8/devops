for ip in 172.31.27.41 172.31.111.141 172.31.125.65
do
	ssh-copy-id $ip
done

for ip in 172.31.27.41 172.31.111.141 172.31.125.65
do
	ssh $ip "hostname -f"
done

for n in 1 2 3
do
	ssh cwinters${n}.mylabserver.com "hostname -f"
done