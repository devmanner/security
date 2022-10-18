ID_X_PUB = $(shell ls ~/.ssh/id_*.pub)
ARCH = $(shell uname -m)

all:
	cp ${ID_X_PUB} .
	docker build --pull --build-arg ARCH=${ARCH} --tag devmanner/kali .
	rm $(notdir ${ID_X_PUB})
