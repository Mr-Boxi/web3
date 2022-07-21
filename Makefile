build:
	sudo docker build -t web3-boxi:v1.0 .
run:
	sudo docker run -p 8888:80 --name web3-boxi -d web3-boxi:v1.0
stop:
	sudo docker stop web3-boxi