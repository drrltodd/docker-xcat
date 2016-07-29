# docker-xcat


Services are started trough systemd, which requires a priviledge container.
Start it by:

'''
docker run --privileged -ti  --rm janfrode/xcat-centos-x86_64
'''


http://xcat-docs.readthedocs.io/en/stable/advanced/docker/dockerized_xcat/dockerized_xcat.html


For dockerized xCAT, there are 3 volumes recommended to save and restore xCAT user data.

    "/install": save the osimage resources under “/install” directory
    "/var/log/xcat/": save xCAT logs
    "/.dbbackup": save and restore xCAT DB tables. You can save the xCAT DB tables with dumpxCATdb -p /.dbbackup/ inside container and xCAT will restore the tables on the container start up.

