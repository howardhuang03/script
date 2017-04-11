#!/usr/bin/env python
# -*- coding:utf-8 -*-
import sys
import json

count = 0
addr = sys.argv[1].decode("utf-8")
print addr

with open('sites.json') as sites_file:
    sites = json.load(sites_file)

for site in sites:
    if addr in site["address"]:
        count += 1
        id = site["hotspots"][0]["id"]
        print "'%s'," % id

print "Total data count: %s" % count
