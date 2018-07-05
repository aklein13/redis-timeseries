
FROM ubuntu

RUN apt-get -y update && apt-get install -y build-essential
RUN apt-get install -y wget
RUN apt-get install -y redis-tools
RUN cd /tmp
RUN wget https://github.com/antirez/redis/archive/4.0-rc2.tar.gz
RUN tar xvzf 4.0-rc2.tar.gz
RUN cd redis-4.0-rc2 && make
RUN cd redis-4.0-rc2 && make install
COPY . /redis-tsdb
RUN cd redis-tsdb/RedisModulesSDK/rmutil && make clean && make
RUN cd redis-tsdb/src && make clean && make

EXPOSE 6379

# -v redis_data:/data
VOLUME ["/data"]

WORKDIR /data

# Save every 5 minutes if at least 1 thing changed
CMD ["/usr/local/bin/redis-server", "--save 300 1", "--bind", "0.0.0.0", "--loadmodule", "/redis-tsdb/src/redis-tsdb-module.so"]
