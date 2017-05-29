#!/usr/bin/env bash

APP_NAME=ms-main
APP_VERSION=v002
HOST_PORT=8081
CONTAINER_PORT=8080

if [ "$1" = "build" ]; then
    # Build image
    docker build --tag "$APP_NAME:$APP_VERSION" .
fi

if [ "$1" = "drun" ]; then
    # Run container with proper ports
    docker run -d --name $APP_NAME -p HOST_PORT:$CONTAINER_PORT $APP_NAME:$APP_VERSION
fi

if [ "$1" = "rmc" ] || [ "$1" = "dremove" ]; then
    # Remove running container
    CONTAINER_ID=$(docker inspect --format="{{.Id}}" $APP_NAME)
    echo "Removing ms-main container with id" : $CONTAINER_ID
    docker rm -f $CONTAINER_ID
fi

if [ "$1" = "rmi" ] || [ "$1" = "dremove" ]; then
    # Remove image
    IMAGE_ID=$(docker images | grep -E 'ms-main.*'$APP_VERSION | awk '{print $3}')
    docker rmi $IMAGE_ID
fi

if [ "$1" = "deploy" ]; then
    kubectl create -f ./kube-service.yml
    kubectl create -f ./kube-deployment.yml
fi

if [ "$1" = "delete" ]; then
    kubectl delete -f ./kube-deployment.yml
    kubectl delete -f ./kube-service.yml
fi




docker ps | grep -E 'ms-main.*'$APP_VERSION | awk '{print $3}'
