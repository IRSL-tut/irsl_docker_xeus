#!/bin/bash

image=$1
res=0

for i in {1..20}
do
    docker pull $image
    res=$?
    if [ ${res} -eq 0 ]; then
        break;
    fi
done

exit ${res}
