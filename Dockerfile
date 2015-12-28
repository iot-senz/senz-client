FROM ubuntu:latest

MAINTAINER Eranga Bandara (erangaeb@gmail.com)

# Update apt-get sources AND install required packages 
RUN apt-get update -y
RUN apt-get install -y build-essential
RUN apt-get install -y python-setuptools
RUN sudo apt-get -y install python-dev
RUN sudo apt-get install -y python-twisted

# Copy files 
ADD . /var/senzc

# Volomue mapping for log directory
WORKDIR /var/senzc
RUN mkdir logs
VOLUME ["/var/senzc/logs"]

# Service run on 9090 port
EXPOSE 9090 

# RUN server
CMD ["python", "/var/senzc/senzc/client.py"]
