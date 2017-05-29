#!/usr/bin/env bash

minikube service ms-main
minikube ip

open $(minikube service ms-main --url)/greeting

chmod -R 755 ./docker-remove.sh
chmod -R 755 ./docker-run.sh
chmod -R 755 ./docker-script.sh