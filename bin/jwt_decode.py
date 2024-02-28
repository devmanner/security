#!/usr/bin/env python3

import jwt
import sys
import json
import base64
import datetime  
import time

def deep_to_string(deep):
    if type(deep) is dict:
        new = dict()
        for key in deep:
            new[key] = deep_to_string(deep[key])
        return new
    elif isinstance(deep, bytes):
        return base64.b64encode(deep).decode("ascii")
    return deep

public_key = ""

if len(sys.argv) == 3:
    public_key = sys.argv[1]
    jwt_token = sys.argv[2]
elif len(sys.argv) == 2:
    jwt_token = sys.argv[1]
else:
    print("Usage: " + sys.argv[0] + " [public_key-file] JWT")
    print("If JWT is - it is read from stdin.")
    print("Return values:")
    print("  0: Parsing and signature verification successful")
    print("     or")
    print("     Parsing succesful and no public key provided for signature.")
    print("  1: Parsing successful, signature verification failed.")
    print("255: Error.")
    exit(-1)

exit_code = 0

if public_key == "":
    try:
        decoded = jwt.api_jwt.decode_complete(jwt_token, options={"verify_signature": False})
        decoded["_comment"] = "No public key provided to verify signature"
    except:
        print("Error parsing JWT")
        exit(-1)
else:
    f = open(public_key)
    key = f.read()
    try:
        decoded = jwt.api_jwt.decode_complete(jwt_token, key, algorithms=["RS256"])
    except:
        try:
            decoded = jwt.api_jwt.decode_complete(jwt_token, jwt_token, options={"verify_signature": False})
            decoded["_comment"] = "Failed to verify signature"
            exit_code = 1
        except:
            print("Error parsing JWT")
            exit(-1)

decoded["_iat"] = datetime.datetime.fromtimestamp(decoded["payload"]["iat"]).strftime( "%Y-%m-%d %H:%M:%S")
decoded["_exp"] = datetime.datetime.fromtimestamp(decoded["payload"]["exp"]).strftime( "%Y-%m-%d %H:%M:%S")
decoded["_expired"] = int(time.time()) > decoded["payload"]["exp"]

print(json.dumps(deep_to_string(decoded), indent=2))
exit(exit_code)
