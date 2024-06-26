. ./comm.sh

mysqlsh --js --uri gradmin:grpass@`hostname`:3310 -e "

x = dba.getCluster()
x.createClusterSet('myclusterset')
"

mysqlsh --js --uri gradmin:grpass@`hostname`:3310 -e "
y = dba.getClusterSet()
y.createReplicaCluster('`hostname`:3340', 'mycluster2', {
	consistency:'BEFORE_ON_PRIMARY_FAILOVER',
	expelTimeout:30,
	memberSslMode:'REQUIRED',
	interactive:false,
	autoRejoinTries:120,
	memberWeight:80,
	recoveryMethod:'incremental'
	})
y = dba.getCluster('mycluster2')
print(y.status())
"

sleep 5

mysqlsh --js --uri gradmin:grpass@`hostname`:3340 -e "
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3350', {exitStateAction:'OFFLINE_MODE', 
	recoveryMethod:'incremental', 
	autoRejoinTries:120,
	memberWeight:70
	})
print(x.status())
"

sleep 5

mysqlsh --js --uri gradmin:grpass@`hostname`:3340 -e "
x = dba.getCluster()
x.addInstance('gradmin:grpass@`hostname`:3360', {exitStateAction:'OFFLINE_MODE', 
	recoveryMethod:'incremental', 
	autoRejoinTries:120,
	memberWeight:60
	})
print(x.status())
"

