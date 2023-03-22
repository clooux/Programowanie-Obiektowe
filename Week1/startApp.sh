#!/bin/bash

docker pull kprzystalski/projobj-pascal:latest
docker run --rm -it -v ${PWD}:/home/student/projobj/ kprzystalski/projobj-pascal:latest fpc z1.pas
docker run --rm -it -v ${PWD}:/home/student/projobj/ kprzystalski/projobj-pascal:latest ./z1