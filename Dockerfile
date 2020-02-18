FROM python:3.7.6-slim

RUN apt-get update && \
    apt-get install -y \
      gcc \
      python3-dev \
      default-libmysqlclient-dev \
      git \
      wget

# Install AWS SSM
RUN wget https://github.com/Droplr/aws-env/raw/v0.4/bin/aws-env-linux-amd64 -O /bin/aws-env && \
  chmod +x /bin/aws-env
  
# Install Supervisor
RUN apt-get install -y supervisor && mkdir /etc/supervisor.d

COPY supervisord.conf /etc/supervisord.conf

# Create user and group
RUN groupadd -g 1000 www && useradd -u 1000 -g www www

RUN mkdir /www && touch /www/docker-volume-not-mounted && chown www:www /www
WORKDIR /www

# Install virtualenv
RUN pip install virtualenv

RUN apt-get autoremove -y

# Supervisor will run gunicorn or celery
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]