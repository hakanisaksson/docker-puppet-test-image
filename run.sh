#!/bin/bash

test -n "$1" && image=$1
test -z "$image" && image=docker-puppet-test-image

echo "Starting container:"
echo "   docker run -h puppet.example.com --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /tmp:/tmp $image"
CONTAINER=$(docker run -h puppet.example.com --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /tmp:/tmp $image)
CONTAINER=$(echo $CONTAINER | cut -c1-12)

echo "To test module in docker container run: "
echo "   docker exec -t -i ${CONTAINER} /testmodule"

echo "To enter docker container run: "
echo "   docker exec -t -i ${CONTAINER} /bin/bash"

#IP=$(docker inspect ${CONTAINER}|grep -w IPAddress|head -1|awk -F\: '{print $2}'|tr -d \"|tr -d \,|sed -e 's/^[ \t]*//')

echo "stop with:"
echo "   docker rm -f ${CONTAINER}"

