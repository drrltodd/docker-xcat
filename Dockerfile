from centos:7
MAINTAINER Jan-Frode Myklebust <janfrode@tanso.net>

ENV container docker
RUN yum -y update; yum clean all
RUN yum -y install systemd; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

ADD xCAT-core.repo /etc/yum.repos.d/xCAT-core.repo
ADD xCAT-dep.repo /etc/yum.repos.d/xCAT-dep.repo

RUN yum -y install xCAT openssh-server
RUN systemctl enable httpd
RUN systemctl enable dhcpd
RUN systemctl enable sshd

ADD rc-local /etc/rc.d/rc.local 
RUN chmod +x /etc/rc.d/rc.local ; systemctl enable rc-local

RUN cp -rf  /install/postscripts  /opt/xcat/ \
	&& rm -rf /install/postscripts ; \
	cp -rf  /install/prescripts  /opt/xcat/ \
	&& rm -rf /install/prescripts; \
	touch /etc/NEEDINIT ;\
	echo "root:cluster" | chpasswd 

CMD ["/usr/sbin/init"]
