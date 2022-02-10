#!/usr/bin/python

import sys
import re
from coolname import generate_slug 

if len(sys.argv) != 7:
	print("Script to anonymize a list of usernames and hashes. Good step to do when auditing passwords.")
	print("Usage: anonymize_hashfile.py file_with_hashes_and_names user_field hash_field delimiter user_output_file hash_output_file")
	print("  file_with_hashes_and_names: Input file. Typically the output of ushadow.")
	print("  user_field: 0-counted field number in file_with_hashes_and_names that contains username")
	print("  hash_field: 0-counted field number in file_with_hashes_and_names that contains password hash")
	print("  delimiter: Character used to split the fields in file_with_hashes_and_names. Same char is used as separator in output")
	print("  user_output_file: Output file that will contain user[delimiter]random_name")
	print("  hash_output_file: Output file that will contain random_name[delimiter]hash")
	exit(-1)

fname_in = sys.argv[1];
usrf = sys.argv[2];
hashf = sys.argv[3];
delim = sys.argv[4];
fname_users = sys.argv[5];
fname_hashes = sys.argv[6];

fh_in = open(fname_in, "r")
fh_users = open(fname_users, "w");
fh_hashes = open(fname_hashes, "w");

for line in fh_in:
	l = re.split(delim, line);
	rnd_name = generate_slug(4)
	fh_users.write(l[int(usrf)]  + delim + rnd_name +"\n")
	fh_hashes.write(rnd_name + delim + l[int(hashf)])

fh_in.close()
fh_users.close()
fh_hashes.close()
