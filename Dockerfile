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
ADD xCAT-repo.gpgkey /etc/pki/rpm-gpg/RPM-GPG-KEY-xCAT

ADD VMware-vSphere-CLI-6.5.0-* /tmp
ADD lnvgy_utl_asu_* /tmp

ADD savestate.sh /root/bin/

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY* ; \
    yum -y install e2fsprogs-devel libuuid-devel openssl-devel perl-devel \
        glibc.i686 zlib.i686 \
        perl-XML-LibXML libncurses.so.5 perl-Crypt-SSLeay \
        tcpdump \
        e2fsprogs which perl-CPAN \
        perl-Archive-Zip perl-Class-MethodMaker uuid-perl perl-SOAP-Lite \
        perl-XML-SAX perl-XML-NamespaceSupport perl-XML-LibXML \
        perl-MIME-Lite perl-MIME-Types perl-MailTools perl-TimeDate uuid libuuid \
        perl-Data-Dump libxml2-devel perl-libwww-perl perl-Test-MockObject perl-Test-Simple \
        perl-Monitoring-Plugin perl-Class-Accessor perl-Config-Tiny perl-Crypt-SSLeay perl-Socket6 ;\
    cd /tmp/[Vv][Mm]ware-v[Ss]phere-* ; \
    ./vmware-install.pl --prefix=/opt/vmwarecli EULA_AGREED=yes --default ;\
    rm -rf /tmp/[Vv][Mm]ware-v[Ss]phere-* ;\
    yum -y install /tmp/lnvgy_utl_asu_* ;\
        rm -f /tmp/lnvgy_utl_asu_* ;\
    yum -y install rsyslog screen bash-completion \
        nmap less man-db xorg-x11-server-utils xorg-x11-xauth xterm ; \
    yum -y install xCAT openssh-server xnba-kvm esxboot-xcat ; \
    yum clean all
ADD tftp.service /usr/lib/systemd/system/tftp.service
RUN systemctl enable httpd; \
    systemctl enable dhcpd; \
    systemctl enable sshd; \
    systemctl enable rsyslog

ADD rc-local /etc/rc.d/rc.local 
RUN chmod +x /etc/rc.d/rc.local ; systemctl enable rc-local

COPY motd /etc/motd

RUN cp -rf  /install/postscripts  /opt/xcat/ \
	&& rm -rf /install/postscripts ; \
	cp -rf  /install/prescripts  /opt/xcat/ \
	&& rm -rf /install/prescripts; \
	touch /etc/NEEDINIT ;\
        echo "X11UseLocalhost no" >> /etc/ssh/sshd_config ;\
        echo "MaxStartups 1024" >> /etc/ssh/sshd_config ;\
	echo "root:cluster" | chpasswd 

CMD ["/usr/sbin/init"]
