ID_X_PUB = $(shell ls ~/.ssh/id_rsa.pub)
ARCH = $(shell uname -m)

all: shadow.txt docker

shadow.txt:
	./mkpasswd.sh user > shadow.txt

docker: Dockerfile
	cp ${ID_X_PUB} .
	docker build --pull --build-arg ARCH=${ARCH} --tag devmanner/kali .
	rm $(notdir ${ID_X_PUB})

clean:
	rm -f shadow.txt

