# Jessie × Docker × Ansible
A minimal foray into the world of ops automation.

## Setup
```
$ git clone git@github.com:wesleybliss/jessie-docker-ansible.git jessie
$ cd jessie
$ npm i
$ npm shrinkwrap
$ docker-compose build
$ docker-compose up
```

## Access the container
`docker exec -ti app /bin/bash`

## See the app running
In the Docker log, you will see
`App listening on [ip] at [port]` - you can hit that in your browser as http://ip:port/.