#!/usr/bin/env python

import sys

for s in ('\033[c', '\033[0c', '\033[>c', '\033[>0c'):
    sys.stdout.write(s)
    print repr(raw_input())
