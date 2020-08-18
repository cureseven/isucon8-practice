.PHONY: gogo slow-log

gogo:
	sudo systemctl stop h2o
	sudo systemctl stop torb.go
	sudo systemctl stop mariadb
	sudo truncate --size 0 /var/log/h2o/access.log
	-sudo truncate --size 0 /var/lib/mysql/mysql-slow.log
	make -C webapp/go build
	sudo systemctl start mariadb
	sleep 2
	sudo systemctl start torb.go
	sudo systemctl start h2o
	sleep 2
	./exec_bench.sh

slow-log:
	sudo mysqldumpslow -s at -t 10 /var/lib/mysql/mysql-slow.log