KEY = key.asn1

all:
	openssl asn1parse -genconf ${KEY} -out newkey.der
	openssl rsa -in newkey.der -inform der -check
	openssl rsa -in newkey.der -inform der -check -pubout

clean:
	rm -f newkey.der
