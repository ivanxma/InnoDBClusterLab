. ./comm.sh

if [ $# -gt 0 ]
then
	MYHOST=$1
	MYPORT=3340
	if [ $# -gt 1 ]
	then
		MYPORT=$2
	fi
else
	MYHOST=`hostname`
	MYPORT=3340
fi

mysqlsh --uri gradmin:grpass@${MYHOST}:${MYPORT} << EOL
print(dba.getClusterSet().status());
print(dba.getCluster().status());
EOL
