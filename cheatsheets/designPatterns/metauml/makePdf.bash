#!/usr/bin/env bash

set -e
set -u

for file in *.mp 
do
    mptopdf ${file}
done

rm -f *.log *.1 *.ps *.mpx

