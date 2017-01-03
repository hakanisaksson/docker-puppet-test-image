FROM centos:7

VOLUME /sys/fs/cgroup /tmp /run

ENV container=docker

#ADD files/puppet.gpg /etc/pki/yum-gpg-keys/puppet.gpg
#ADD files/extra.repo /etc/yum.repos.d/extra.repo
RUN rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm

RUN yum install -y \
        augeas \
        iputils \
        net-tools \
        hostname \
        vim \
        nc \
        ntp \
        ntpdate \
        mlocate \
        certmonger \
        nss-tools \
        yum-utils \
        initscripts \
        puppet \
        puppet-server \
        vim \
        wget \
        tar \
        rsync \
        strace \
        sysstat \
        tcpdump \
        openssh-clients \
        rsyslog \
        yum-utils; \
   yum clean all


# systemd
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] \
|| rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

ADD files/puppetmaster.service /usr/lib/systemd/system/
RUN systemctl enable puppetmaster

# prepare puppet
RUN mkdir -p /etc/puppet/manifests /etc/puppet/hiera /etc/puppet/modules/environment/test
ADD files/puppet.conf /etc/puppet/puppet.conf
ADD files/site.pp /etc/puppet/manifests/site.pp
ADD files/common.yaml /etc/puppet/hiera/common.yaml
ADD files/hiera.yaml /etc/puppet/hiera.yaml
ADD files/environment.conf /etc/puppet/modules/environment/test/environment.conf
RUN puppet module install puppetlabs-stdlib

ADD files/testmodule /

CMD ["/usr/sbin/init"]
