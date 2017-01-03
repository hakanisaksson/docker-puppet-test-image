#!/bin/bash
#
# Verify that the image and test script works
#
image=$1
test -z "$image" && image=docker-puppet-test-image

err() {
   echo "[ERROR] $*"
   exit 1
}

echo "### Test script"
docker run -it -v /tmp:/tmp docker-puppet-test-image /testmodule
test $? -eq 2 || err "Failed test"
echo "Test OK"

echo "### Test class with noop"
docker run -it -v /tmp:/tmp  $image /testmodule -d -n -e test https://forge.puppet.com/v3/files/puppetlabs-motd-1.4.0.tar.gz
test $? -eq 0 || err "Failed test"
echo "### Test OK"

echo "### Test class without noop"
docker run -it -v /tmp:/tmp  $image /testmodule https://forge.puppet.com/v3/files/puppetlabs-motd-1.4.0.tar.gz
test $? -eq 2 || err "Failed test"
echo "### Test OK"

echo "### Test mod on local path"
docker run -it -v /tmp:/tmp docker-puppet-test-image /testmodule -p /tmp/verify https://forge.puppet.com/v3/files/puppetlabs-motd-1.4.0.tar.gz
test $? -eq 2 || err "Failed test"
echo "### Test OK"

CONTAINER=$(docker run -h puppet.example.com --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /tmp:/tmp $image)
CONTAINER=$(echo $CONTAINER | cut -c1-12)
echo docker exec -t -i $CONTAINER /testmodule -i stdlib https://forge.puppet.com/v3/files/puppetlabs-ntp-4.2.0.tar.gz
docker exec -t -i $CONTAINER /testmodule -i stdlib https://forge.puppet.com/v3/files/puppetlabs-ntp-4.2.0.tar.gz
test $? -ne 0 || err "Failed test" ### script exit code is not returned
echo docker rm -f $CONTAINER
docker rm -f $CONTAINER
echo "### Verify done"

