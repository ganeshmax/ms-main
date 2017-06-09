#!/usr/bin/env bash

APP_NAME=ms-main
APP_VERSION=v002
HOST_PORT=8081
CONTAINER_PORT=8080

# Build image
docker_build() {
  docker build --tag "$APP_NAME:$APP_VERSION" .
}

# Run container with proper ports
docker_run() {
    docker run -d --name $APP_NAME -p HOST_PORT:$CONTAINER_PORT $APP_NAME:$APP_VERSION
}

# Remove running container
docker_remove_container() {
    CONTAINER_ID=$(docker inspect --format="{{.Id}}" $APP_NAME)
    echo "Removing ms-main container with id" : $CONTAINER_ID
    docker rm -f $CONTAINER_ID
}

# Remove image
docker_remove_image() {
    IMAGE_ID=$(docker images | grep -E 'ms-main.*'$APP_VERSION | awk '{print $3}')
    docker rmi $IMAGE_ID
}

# deploy kube resource
kube_deploy() {
    kubectl create -f ./kubefile.yml
}

# delete kube resource
kube_delete() {
    kubectl delete -f ./kubefile.yml
}

if [ "$1" = "dbuild" ]; then
    docker_build
fi

if [ "$1" = "drun" ]; then
    docker_run
fi

if [ "$1" = "drmc" ] || [ "$1" = "drm" ]; then
    docker_remove_container
fi

if [ "$1" = "drmi" ] || [ "$1" = "drm" ]; then
    docker_remove_image
fi

if [ "$1" = "kdeploy" ]; then
    kube_deploy
fi

if [ "$1" = "kdelete" ]; then
    kube_delete
fi

if [ "$1" = "deploy" ]; then
    docker_build
    kube_deploy
    open $(minikube service ms-main --url)/greeting
fi

if [ "$1" = "delete" ]; then
    kube_delete
    docker_remove_image
fi


