FROM registry.cn-shenzhen.aliyuncs.com/l7-bug-tool/mysql:latest
#ADD https://raw.githubusercontent.com/alibaba/nacos/develop/distribution/conf/mysql-schema.sql /docker-entrypoint-initdb.d/mysql-schema.sql
# https://github.com/alibaba/nacos/blob/master/distribution/conf/mysql-schema.sql
COPY ./mysql-schema.sql /docker-entrypoint-initdb.d/mysql-schema.sql
RUN chown -R mysql:mysql /docker-entrypoint-initdb.d/mysql-schema.sql
EXPOSE 3306
CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]