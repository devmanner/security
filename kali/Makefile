ID_X_PUB = $(shell ls ~/.ssh/id_ed25519.pub)
ARCH = $(shell uname -m)

all: shadow.txt docker

shadow.txt:
	./mkpasswd.sh user shadow.txt
	chmod 600 shadow.txt

docker: Dockerfile
	cp ${ID_X_PUB} .
	docker build --pull --build-arg ARCH=${ARCH} --tag devmanner/kali .
	rm $(notdir ${ID_X_PUB})

run:
	docker run -it -p 2222:22 devmanner/kali

clean:
	rm -f shadow.txt
	docker rmi -f devmanner/kali

