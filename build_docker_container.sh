if [ -z $PROJ_NM ]; then
  echo "Set PROJ_NM (e.g. 'export PROJ_NM=test_proj')"
  exit 1
fi
PROJECT=$PROJ_NM
CONTAINER="${PROJECT}_app_1"
echo "$0: PROJECT=${PROJECT}"
echo "$0: CONTAINER=${CONTAINER}"


EXISTING_CONTAINER_ID=`docker ps -aq -f name=${CONTAINER}`
if [ ! -z "${EXISTING_CONTAINER_ID}" ]; then
  echo "The container name ${CONTAINER} is already in use" 1>&2
  echo ${EXISTING_CONTAINER_ID}
  exit 1
fi


echo "starting build"
docker-compose -p ${PROJECT} -f ./docker/docker-compose.yaml up --build
