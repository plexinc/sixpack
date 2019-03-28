FROM ubuntu:18.04

ENV SUPERVISORD_APP_VERSION       3.3.3

RUN apt-get update && apt-get install -y python python-pip wget

# supervisord
RUN pip install supervisor-stdout
RUN pip install https://github.com/Supervisor/supervisor/archive/${SUPERVISORD_APP_VERSION}.zip

# redis 
RUN wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install

# OAuth proxy
RUN wget https://github.com/bitly/oauth2_proxy/releases/download/v2.2/oauth2_proxy-2.2.0.linux-amd64.go1.8.1.tar.gz \
    -O /oauth2_proxy.tar.gz && \
  tar xvfz /oauth2_proxy.tar.gz -C / && \
  mkdir -p /usr/local/bin && \
  cp /oauth2_proxy-2.2.0.linux-amd64.go1.8.1/oauth2_proxy /usr/local/bin/ && \
  rm -rf /oauth2_proxy*

ADD . /sixpack/
RUN pip install -r /sixpack/requirements.txt
RUN pip install sixpack

ADD ./docker-config.yml /sixpack/
ADD ./supervisord.conf /etc/

CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]
