#!/bin/bash

mysqld --user=mysql --init-file=/docker-entrypoint-initdb.d/init.sql &
vsftpd /etc/vsftpd.conf &
smbd --foreground --no-process-group --debug-stdout &
bentoml serve service:Summarization