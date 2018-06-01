#!/usr/bin/python

import crypt, getpass,os,base64, sys;

def print_hash(passwd):
	print crypt.crypt(passwd, "$6$"+base64.b64encode(os.urandom(16))+"$")


if sys.stdin.isatty():
	print_hash(getpass.getpass())
else:
	for line in sys.stdin:
		print_hash(line)
