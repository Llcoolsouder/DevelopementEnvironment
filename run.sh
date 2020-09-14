#!/bin/bash

xhost +local:docker
docker run -it -e DISPLAY=$DISPLAY --net=host -v $PWD:/mnt/ --user $(id -u):$(id -g) dev-env
