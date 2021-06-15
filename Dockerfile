FROM 1and1internet/debian-9-nginx-php-phpmyadmin:latest
ARG DEBIAN_FRONTEND=noninteractive

COPY files/ /

RUN \
  groupadd mysql && \
  useradd -g mysql mysql && \
  apt-get update && \
  apt-get install -y gettext-base mariadb-server pwgen python && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/lib/mysql && \
  mkdir --mode=0777 /var/lib/mysql /var/run/mysqld && \
  chown mysql:mysql /var/lib/mysql && \
  printf '[mysqld]\nskip-name-resolve\n' > /etc/mysql/conf.d/skip-name-resolve.cnf && \
  chmod 777 /docker-entrypoint-initdb.d && \
  chmod 0777 -R /var/lib/mysql /var/log/mysql && \
  chmod 0775 -R /etc/mysql && \
  chmod 0755 -R /hooks && \
  cd /opt/configurability/src/mariadb_config_translator && \
  curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py && \
  python /tmp/get-pip.py && \
  pip --no-cache install --upgrade pip && \
  pip --no-cache install --upgrade . && \
  pip install tzupdate

ENV DISABLE_PHPMYADMIN=0 \
    PMA_ARBITRARY=0 \
    PMA_HOST=localhost \
    MYSQL_GENERAL_LOG=0 \
    MYSQL_QUERY_CACHE_TYPE=1 \
    MYSQL_QUERY_CACHE_SIZE=16M \
    MYSQL_QUERY_CACHE_LIMIT=1M

EXPOSE 3306 8080
VOLUME /var/lib/mysql/
