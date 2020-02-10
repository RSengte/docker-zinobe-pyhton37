FROM python:3.7.6-slim

RUN apt update && \
  apt install -y \
    gcc \
    python3-dev \
    default-libmysqlclient-dev \
    git \
    wget

# Install AWS SSM
RUN wget https://github.com/Droplr/aws-env/raw/v0.4/bin/aws-env-linux-amd64 -O /bin/aws-env && \
  chmod +x /bin/aws-env
  
# Install Supervisor
RUN apt install -y supervisor && mkdir /etc/supervisor.d

# Create user and group
RUN groupadd -g 1000 www && useradd -u 1000 -g www www

RUN mkdir /www && touch /www/docker-volume-not-mounted && chown www:www /www
WORKDIR /www

RUN pip3 install --upgrade pip setuptools

RUN apt autoremove -y

# Supervisor will run gunicorn or celery
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]