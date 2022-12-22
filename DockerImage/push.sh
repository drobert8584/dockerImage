#!/usr/bin/env bash

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "build & push docker image to dockerHub"
   echo
   echo "Syntax: push.sh [-h|v|p|r|t]"
   echo "options:"
   echo "h     Print this Help."
   echo "v     Verbose mode."
   echo "a     docker hub account (mandatory)."    
   echo "p     set target php version (default : 8.0)."
   echo "r     set target image name (default : php8)."
   echo "t     set target image tag (default : 80)"
   echo "x     set targeted Xdebug version (default : 3.2.0)"
   echo
}

################################################################################
# Default values                                                               #
################################################################################
phpversion="8.0"
imagename="php8"
tagname="80"
xdebug="3.2.0"
verbose=0

################################################################################
# Option processing                                                            #
################################################################################

while getopts ":h:p:r:t:x:a:v" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      p) # Enter PHP version
         phpversion=$OPTARG;;
      r) # Enter image name 
         imagename=$OPTARG;;
      t) # Enter image tag name 
         tagname=$OPTARG;;
      x) # Enter Xdebug version 
         xdebug=$OPTARG;;
      a) # Enter account 
         account=$OPTARG;;
      v) # Verbose
         verbose=1;;
      \?) # incorrect option
         echo "Error: Invalid option"
         Help
         exit;;
   esac
done

################################################################################
# Mandotory check                                                              #
################################################################################

if [ -z "$account" ]
then
  echo "docker hub account is mandatory to push image"
  exit
fi

################################################################################
# Main elements                                                                #
################################################################################

if [[ "$verbose" -eq 1 ]]
then
    echo "#####"
    echo "creation of $imagename:$tagname based on PHP $phpversion with Xdebug $xdebug"
    echo "docker build --build-arg PHP_VERSION=$phpversion --build-arg XDEBUG_VERSION=$xdebug -t $imagename:$tagname ."
    echo "#####"
fi
docker build --build-arg PHP_VERSION=$phpversion --build-arg XDEBUG_VERSION=$xdebug -t $imagename:$tagname .

if [[ "$verbose" -eq 1 ]]
then
    echo "#####"
    echo "Tagging image"
    echo "docker tag $imagename:$tagname $account/$imagename:$tagname"
    echo "#####"
fi
docker tag $imagename:$tagname $account/$imagename:$tagname

if [[ "$verbose" -eq 1 ]]
then
    echo "#####"
    echo "Login to dockerhub"
    echo "docker login"
    echo "#####"
fi
docker login

if [[ "$verbose" -eq 1 ]]
then
    echo "#####"
    echo "Push to dockerhub"
    echo "docker push $account/$imagename:$tagname"
    echo "#####"
fi
docker push $account/$imagename:$tagname

