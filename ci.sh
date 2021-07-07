#!/bin/sh

echo "*** STARTING Lint and Unit Tests `date` ***"
yarn run -s lint
yarn run -s test:unit
yarn run -s test:front
echo "*** FINISHED Lint and Unit Tests `date` ***"

# Postgres
echo "*** STARTING Postgres Tests `date` ***"
apt-get update && apt-get install -y postgresql-client
psql -c 'create database strapi_test;' -U postgres -h postgres -p 5432
yarn run -s test:generate-app -- '--dbclient=postgres --dbhost=postgres --dbport=5432 --dbname=strapi_test --dbusername=postgres --dbpassword='
yarn run -s test:start-app & ./node_modules/.bin/wait-on http://localhost:1337
yarn run -s test:e2e      
echo "*** FINISHED Postgres Tests `date` ***"

# MySQL
echo "*** STARTING MySQL Tests `date` ***"
apt-get update && apt-get install -y mysql-client
yarn run -s test:generate-app -- '--dbclient=mysql --dbhost=mysql --dbport=3306 --dbname=strapi_test --dbusername=ci --dbpassword=passw0rd'
yarn run -s test:start-app & ./node_modules/.bin/wait-on http://localhost:1337
yarn run -s test:e2e
echo "*** FINISHED MySQL Tests `date` ***"
      
# SQL Lite
echo "*** STARTING SQLLite Tests `date` ***"
yarn run -s test:generate-app -- '--dbclient=sqlite --dbfile=./tmp/data.db'
yarn run -s test:start-app & ./node_modules/.bin/wait-on http://localhost:1337
yarn run -s test:e2e
echo "*** FINISHED SQLLite Tests `date` ***"
    
# Mongo
echo "*** STARTING Mongo Tests `date` ***"
yarn run -s test:generate-app -- '--dbclient=mongo --dbhost=mongo --dbport=27017 --dbname=strapi_test --dbusername= --dbpassword='
yarn run -s test:start-app & ./node_modules/.bin/wait-on http://localhost:1337
yarn run -s test:e2e
echo "*** FINISHED Mongo Tests `date` ***"