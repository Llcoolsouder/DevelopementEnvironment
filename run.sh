#!/bin/bash

xhost +local:docker
docker run -it -e DISPLAY=$DISPLAY --net=host -v /:/mnt/ dev-env
