#!/bin/bash
#
# Please run: ./build.sh in this directory to check this assignment

# This script will build the docker image task2 first
# Then it will build the docker containers with required network
# topo descripted in assignment 2.
# Here is the copy of assignment 2
# 
# We need to create the following setup using dockers.
#  
#  
#  
# You can use one of these images for the same:
# 1.	debian:stretch
# 2.	debian:buster
# 3.	ubuntu:18.04
# #
# Other packages needed:
# 1.	You need to have the above figgle package as part of the docker install.
# 2.	Ensure that the docker container does not have extraneous packages which we do not need like ifconfig, vim and babeltrace.
# 3.	All dockers should have hostnames as specified above.
# 
# Also, the above setup should be built using any script (you can use docker-compose if it helps).
#  
# Result/Outputs:
# 1.	The script for building the above setup along with instructions on how to execute it.
# 2.	Additional packages as mentioned should be present
# 3.	Extraneous packages should be removed.
# 4.	Ping from each docker to the next should be successful as long as they are directly connected.
#
docker build --tag task2 .

echo "Clean up previous generated containers and networks"
docker rm -f SpineA SpineB SpineC LeafA LeafB LeafC LeafD
docker network rm -f mynetA mynetB mynetC

# build multiple networks
echo "Create networks"
docker network create --subnet=192.168.2.0/23 --ip-range=192.168.2.0/24 --gateway=192.168.2.1 mynetA
docker network create --subnet=192.169.2.0/23 --ip-range=192.169.2.0/24 --gateway=192.169.2.1 mynetB
docker network create --subnet=192.169.4.0/23 --ip-range=192.169.4.0/24 --gateway=192.169.4.1 mynetC
docker network ls

# build Spines with multiple NICs attached
echo "Creating Spine containers and attaching NICs"
docker run --name SpineA --net mynetA --ip 192.168.2.11 -itd task2
docker network connect mynetB SpineA
docker network connect mynetC SpineA

docker run --name SpineB --net mynetB --ip 192.169.2.11 -itd task2
docker network connect mynetC SpineB
docker network connect mynetA SpineB

docker run --name SpineC --net mynetC --ip 192.169.4.11 -itd task2
docker network connect mynetA SpineC
docker network connect mynetB SpineC

# build Leafs with multiple NICs attached
echo "Creating Leaf containers and attaching NICs"
docker run --name LeafA --net mynetA --ip 192.168.2.12 -itd task2
docker network connect mynetB LeafA
docker network connect mynetC LeafA

docker run --name LeafB --net mynetB --ip 192.169.2.12 -itd task2
docker network connect mynetC LeafB
docker network connect mynetA LeafB

docker run --name LeafC --net mynetC --ip 192.169.4.12 -itd task2
docker network connect mynetA LeafC
docker network connect mynetB LeafC

docker run --name LeafD --net mynetA --ip 192.168.2.13 -itd task2
docker network connect mynetB LeafD
docker network connect mynetC LeafD

docker container ls

echo ""
echo "Now you can get into any container and use ping to see their connectivities"
echo "Sample: run 'docker exec -it SpineA bash'"
echo ""
echo "To take out this assignment network and containers, run the following commands:"
echo "docker rm -f SpineA SpineB SpineC LeafA LeafB LeafC LeafD"
echo "docker network rm -f mynetA mynetB mynetC"
