# Pyhton 3.7

Python 3.7 with supervisord.

**Base image:** `python:3.7.6-slim`

**WORKDIR:** `/www`

Add **aws-env** util form AWS SSM ([aws-env](https://github.com/Droplr/aws-env/))

# Supervisor - Daemon config
```conf
[unix_http_server]
file = /run/supervisord.sock
chmod = 0760
chown = www:www

[supervisord]
pidfile=/run/supervisord.pid
; Log information is already being sent to /dev/stdout by default, which gets captured by Docker logs.
; Storing log information inside the contaner will be redundant, hence using /dev/null here
logfile = /dev/null
logfile_maxbytes = 0

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl = unix:///run/supervisord.sock
```

## Gunicorn (example)

```conf
[program:app]
directory=/www
command=gunicorn --chdir=/www --env DJANGO_SETTINGS_MODULE=config.settings.production config.wsgi --bind=0.0.0.0:8001 --workers=2
autostart=true
autorestart=true
stderr_logfile=/www/gunicorn.err.log
stdout_logfile=/www/gunicorn.out.log
user=www
group=www
environment=LANG=en_US.UTF-8,LC_ALL=en_US.UTF-8
```

## Using virtualenv (example)

```bash
# Make virtualenv
virtualenv venv

# Enable virtualenv
source venv
```

# Docker compose (example)

docker-compose.yml
```yml
version: '3'

services:
  app:
    image: zinobe/python37
    volumes:
      - ./:/www
      - ./supervisord.conf:/etc/supervisord.conf:ro
      - ./entrypoint:/entrypoint:ro
    env_file:
      - /.env
    command: /entrypoint
```