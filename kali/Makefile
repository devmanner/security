ID_X_PUB = $(shell ls ~/.ssh/id_*.pub)

all:
	cp ${ID_X_PUB} .
	docker build --pull --tag devmanner/kali .
	rm $(notdir ${ID_X_PUB})
