KEY = key.asn1

all: keys

keys:
	openssl asn1parse -genconf ${KEY} -out newkey.der
	openssl rsa -in newkey.der -inform der > private.pem
	openssl rsa -in private.pem -check -noout
	openssl rsa -in newkey.der -inform der -pubout > public.pem
clean:
	rm -f newkey.der public.pem private.pem
