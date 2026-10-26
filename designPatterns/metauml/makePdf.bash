#!/usr/bin/env bash

set -e
set -u

for file in *.mp 
do
    mptopdf ${file}
done

rm *.log
rm *.1
rm *.ps

