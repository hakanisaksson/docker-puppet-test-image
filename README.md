# ABOUT
This Dockerfile build a CentOS 7.x based image with puppet 3.x.x for smoke-testing puppet modules. 
Can test modules with puppet apply or running full master/agent mode.
Can test modules that has been downloaded locally in the /tmp dir or download modules directly from a forge.

# BUILD
to build locally:
```bash
docker build -t docker-puppet-test-image .
```
or to build centos6:
docker build -f Dockerfile.centos6 -t docker-puppet-test-image-centos6 .

# RUN
to show help:
```bash
docker run -it -v /tmp:/tmp docker-puppet-test-image /testmodule
```
or to daemonize (to start puppet master):
```bash
./run.sh
```

# TEST
test locally prepared puppet module:
```bash
docker run -it  -v /tmp:/tmp -e DEBUG='1' docker-puppet-test-image /testmodule /tmp/modulepath/mymod/
```

or download directly from forge:
```bash
docker run -it -v /tmp:/tmp -e MODURL='https://forge.puppet.com/v3/files/puppetlabs-motd-1.4.0.tar.gz' docker-puppet-test-image /testmodule
```
or with systemd enabled:
```bash
docker run -h puppet.example.com --privileged -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /tmp:/tmp docker-puppet-test-image
docker exec -t -i <containerid> /testmodule -a https://forge.puppet.com/v3/files/puppetlabs-ntp-4.2.0.tar.gz
```

# NOTES
All puppet modules that start or stop services must be run through systemd, i.e. in puppet runs with a master or you will get error "Failed to get D-Bus connection: Operation not permitted" on centos7.
puppet 4.x modules can be tested with option -e PUPPETOPTS="--parser=future"
