#!/usr/bin/python3

import hashlib,binascii
import getpass,sys

def ntlm_hash(passwd):
	hash = hashlib.new('md4', passwd.encode('utf-16le')).digest()
	return binascii.hexlify(hash)

if sys.stdin.isatty():
	print(ntlm_hash(getpass.getpass()))
else:
	for line in sys.stdin:
		print(ntlm_hash(line))

