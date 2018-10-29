#!/bin/zsh
export DOCKER_USER_ID=onlydocker
export NGINX_IP='172.21.0.2'
export WEBJAVA_IP='172.21.0.3'
export LOGIC_IP='172.21.0.4'
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Clean up'
echo '--------------------------------------------------------------------------------'
docker container stop $DOCKER_USER_ID'_c2'
docker container stop $DOCKER_USER_ID'_c3'
docker container stop $DOCKER_USER_ID'_c1'
docker container rm $DOCKER_USER_ID'_c2'
docker container rm $DOCKER_USER_ID'_c3'
docker container rm $DOCKER_USER_ID'_c1'
docker network rm $DOCKER_USER_ID
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Create the network'
echo '--------------------------------------------------------------------------------'
docker network create --subnet=172.21.0.0/16 $DOCKER_USER_ID
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Images creation'
echo '--------------------------------------------------------------------------------'
cd ./sa-frontend
#npm run build
docker build -f Dockerfile -t $DOCKER_USER_ID/sentiment-analysis-frontend .
cd ../sa-logic
docker build -f Dockerfile -t $DOCKER_USER_ID/sentiment-analysis-logic .
cd ../sa-webapp
#mvn install
docker build -f Dockerfile -t $DOCKER_USER_ID/sentiment-analysis-web-app .
echo ''
echo '--------------------------------------------------------------------------------'
echo 'Run the containers'
echo '--------------------------------------------------------------------------------'
cd ../sa-frontend
docker run --net $DOCKER_USER_ID --ip $NGINX_IP --name=$DOCKER_USER_ID'_c1' -d -p 80:80 $DOCKER_USER_ID/sentiment-analysis-frontend
cd ../sa-logic
docker run --net $DOCKER_USER_ID --ip $LOGIC_IP --name=$DOCKER_USER_ID'_c3' -d -p 5050:5000 $DOCKER_USER_ID/sentiment-analysis-logic
cd ../sa-webapp
docker run --net $DOCKER_USER_ID --ip $WEBJAVA_IP --name=$DOCKER_USER_ID'_c2' -d -p 8080:8080 -e SA_LOGIC_API_URL='http://'$LOGIC_IP':5000' $DOCKER_USER_ID/sentiment-analysis-web-app
echo ''
echo ''