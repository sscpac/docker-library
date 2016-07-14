#!/bin/sh

# Initialize first run
if [[ -e /.firstrun ]]; then

  echo "Waiting for MongoDB service to start"
  while ! nc -vz soaf-mongo 27017; do sleep 1; done

  echo "Seeding soafDB" 
  /usr/bin/mongorestore -h soaf-mongo --db soafDB /dump

  rm -rf /.firstrun /dump
fi

catalina.sh run
