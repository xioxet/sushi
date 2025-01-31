FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    bash \
    vsftpd \
    samba \
    mysql-server \
    mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/cane -s /bin/bash cane && \
    echo "cane:yourepullingthetriggerallwrong" | chpasswd && \
    mkdir -p /var/run/vsftpd/empty && \
    chown cane:cane /home/cane && \
    echo "local_enable=YES" >> /etc/vsftpd.conf && \
    echo "chroot_local_user=YES" >> /etc/vsftpd.conf && \
    echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf && \
    echo "pasv_enable=YES" >> /etc/vsftpd.conf && \
    echo "pasv_min_port=10000" >> /etc/vsftpd.conf && \
    echo "pasv_max_port=10100" >> /etc/vsftpd.conf && \
    echo "local_root=/bentoml" >> /etc/vsftpd.conf && \
    echo "write_enable=YES" >> /etc/vsftpd.conf

RUN mkdir -p /unhidden_share && \
    chmod 777 /unhidden_share && \
    mkdir -p /hidden_share && \
    chmod 777 /hidden_share && \
    echo "[global]" >> /etc/samba/smb.conf && \
    echo "   map to guest = Bad User" >> /etc/samba/smb.conf && \
    echo "   security = user" >> /etc/samba/smb.conf && \
    echo "   client min protocol = CORE" >> /etc/samba/smb.conf && \  
    echo "   client max protocol = SMB3" >> /etc/samba/smb.conf && \
    echo "[unhidden_share]" >> /etc/samba/smb.conf && \
    echo "   path = /unhidden_share" >> /etc/samba/smb.conf && \
    echo "   read only = yes" >> /etc/samba/smb.conf && \
    echo "   browsable = yes" >> /etc/samba/smb.conf && \
    echo "   writable = no" >> /etc/samba/smb.conf && \
    echo "   guest ok = yes" >> /etc/samba/smb.conf && \
    echo "   create mask = 0777" >> /etc/samba/smb.conf && \
    echo "   directory mask = 0777" >> /etc/samba/smb.conf && \
    echo "[hidden_share]" >> /etc/samba/smb.conf && \
    echo "   path = /hidden_share" >> /etc/samba/smb.conf && \
    echo "   read only = yes" >> /etc/samba/smb.conf && \
    echo "   browsable = no" >> /etc/samba/smb.conf && \
    echo "   writable = no" >> /etc/samba/smb.conf && \
    echo "   guest ok = yes" >> /etc/samba/smb.conf && \
    echo "   create mask = 0777" >> /etc/samba/smb.conf && \
    echo "   directory mask = 0777" >> /etc/samba/smb.conf

RUN ln -s /bentoml /home/cane/bentoml
WORKDIR /bentoml

COPY bentoml/requirements.txt .
COPY unhidden_share /unhidden_share
COPY hidden_share /hidden_share

COPY haystack /flag_haystack
COPY user.txt /home/cane/user.txt
COPY flag_printer /flag_printer
RUN chmod -rwx /flag_printer

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod -R 755 /var/run/mysqld
COPY mysql/mysql.cnf /etc/mysql/conf.d/mysql.cnf
COPY mysql/init.sql /docker-entrypoint-initdb.d/init.sql
RUN chown -R mysql:mysql /docker-entrypoint-initdb.d/

RUN --mount=type=cache,target=/root/.cache \ 
    pip3 install -r requirements.txt

COPY bentoml .
EXPOSE 3000 21 10000-10100 445

COPY start_services.sh /start_services.sh
RUN chmod +x /start_services.sh

CMD ["/start_services.sh"]