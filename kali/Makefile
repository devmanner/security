all:
	cp ~/.ssh/id_rsa.pub .
	docker build --pull --tag devmanner/kali .
	rm -f id_rsa.pub
