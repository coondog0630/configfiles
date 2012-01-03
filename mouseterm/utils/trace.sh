#!/bin/sh
DLYD_SHARED_REGION=avoid
export DLYD_SHARED_REGION
/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal &
sudo dtrace -b 32m -s trace.d -o trace.out -p "$!"
