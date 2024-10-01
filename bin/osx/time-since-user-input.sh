#!/usr/bin/env bash

/usr/sbin/ioreg -c IOHIDSystem |
    /usr/bin/sed -e '/HIDIdleTime/ !{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q'
