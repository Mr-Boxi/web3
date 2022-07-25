install_plugin:
	npm install gitbook-plugin-expandable-chapters-small
	npm install gitbook-plugin-anchor-navigation-ex
	npm install gitbook-plugin-splitter
build_book: install_plugin
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
rebuild: remove install_plugin
	git pull
	gitbook build
	sudo docker build -t web3-boxi:v1.0 .
publish: build_docker_image run

republish: rebuild run