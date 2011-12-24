#!/usr/bin/env python

import sys
sys.stdout.write('\033[?1002h')
print repr(raw_input())
