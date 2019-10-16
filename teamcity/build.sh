echo "*** SETUP ***"

yarn setup
yarn global add -g wait-on

echo "*** STARTING UNIT TESTS ***"

yarn run -s lint
yarn run -s test:unit
yarn run -s test:front

echo "*** STARTING POSTGRES E2E TESTS ***"

apt-get update && apt-get install -y postgresql-client
psql -c 'drop database strapi_test;' -U postgres -h localhost -p 5432
psql -c 'create database strapi_test;' -U postgres -h localhost -p 5432
yarn run -s test:generate-app -- '--dbclient=postgres --dbhost=localhost --dbport=5432 --dbname=strapi_test --dbusername=postgres --dbpassword='
yarn run -s test:start-app & ./node_modules/.bin/wait-on http://localhost:1337
yarn run -s test:e2e

echo "*** STARTING MYSQL E2E TESTS ***"

apt-get update && apt-get install -y mysql-client
yarn run -s test:generate-app -- '--dbclient=mysql --dbhost=localhost --dbport=3306 --dbname=strapi_test --dbusername=ci --dbpassword=passw0rd'
yarn run -s test:start-app & ./node_modules/.bin/wait-on http://localhost:1337
yarn run -s test:e2e

echo "*** STARTING SQLITE TESTS ***"

yarn run -s test:generate-app -- '--dbclient=sqlite --dbfile=./tmp/data.db'
yarn run -s test:start-app & ./node_modules/.bin/wait-on http://localhost:1337
yarn run -s test:e2e

echo "*** STARTING MONGO E2E TESTS ***"

yarn run -s test:generate-app -- '--dbclient=mongo --dbhost=localhost --dbport=27017 --dbname=strapi_test --dbusername= --dbpassword='
yarn run -s test:start-app & ./node_modules/.bin/wait-on http://localhost:1337
yarn run -s test:e2e
