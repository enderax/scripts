#!/usr/bin/env python
import sys
import os

first = []
second = []

if len(sys.argv) != 3:
    sys.stderr.write('Usage: unique_array.py file1.txt file2.txt')
    sys.exit(1)

if os.path.exists(sys.argv[1]):
	for row in open(sys.argv[1],"r").readlines():
  		first.append(row.strip())

if os.path.exists(sys.argv[2]):
	for row in open(sys.argv[2],"r").readlines():
  		second.append(row.strip())

output = tuple(set(first) - set(second))

for i in output:
    print i
