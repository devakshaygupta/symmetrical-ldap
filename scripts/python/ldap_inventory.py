#!/usr/bin/env python3

import os
from ldap3 import Server, Connection, ALL
from dotenv import load_dotenv

# Load environment variables from the .env file (if present)
load_dotenv()

LDAP_HOST = 'localhost'
LDAP_PORT = 1389
LDAP_BASE_DN = 'dc=akshaygupta,dc=click'
LDAP_ADMIN_DN = os.getenv('LDAP_ADMIN_DN')
LDAP_ADMIN_PASSWORD = os.getenv('LDAP_ADMIN_PASSWORD')


server = Server(LDAP_HOST, port=LDAP_PORT, get_info=ALL)
conn = Connection(server, user=LDAP_ADMIN_DN, password=LDAP_ADMIN_PASSWORD)

if not conn.bind():
    print('Failed to bind to LDAP server.')
else:
    # Search for all entries in the directory
    SEARCH_BASE = LDAP_BASE_DN
    SEARCH_FILTER = '(objectClass=*)'  # Matches all objects
    attributes = ['*']  # Retrieve all attributes

    if conn.search(SEARCH_BASE, SEARCH_FILTER, attributes=attributes):
        for entry in conn.entries:
            print(entry)
    else:
        print('Search failed or no entries found.')

conn.unbind()
print('Connection closed.')
