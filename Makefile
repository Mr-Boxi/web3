publish:_publish
_publish: build_docker_image run

build_book:
	npm install gitbook-plugin-expandable-chapters-small
	npm install gitbook-plugin-anchor-navigation-ex
	gitbook build
build_docker_image: build_book
	sudo docker build -t web3-boxi:v1.0 .
run:
	sudo docker run -p 8888:80 --name web3-boxi -d web3-boxi:v1.0
stop:
	sudo docker stop web3-boxi
remove: stop
	sudo docker rm web3-boxi
	sudo docker rmi web3-boxi:v1.0
rebuild: remove
	git pull
	gitbook build
	sudo docker build -t web3-boxi:v1.0 .
republish: rebuild run