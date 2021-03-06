#!/bin/bash

DCR_IMAGE_VERSION=1.11.2-r1

DCR_NAME=nginx-gateway
DCR_IMAGE=canterburymedia/nginx-gateway:${DCR_IMAGE_VERSION}

DCR_VOLUME=/var/lib/nginx-gateway

DEBUG=false
ULIMIT=655360
ENABLE_CUSTOM_ERROR_PAGE=true
CERT_EMAIL=tech@canterburymedia.net

#ulimit -n ${ULIMIT}
docker rm -f ${DCR_NAME}
rm -f "${DCR_VOLUME}/letsencrypt/.lck"

# http://serverfault.com/questions/786389/nginx-docker-container-cannot-see-client-ip-when-using-iptables-false-option#answer-788088
docker run -d --name ${DCR_NAME} \
                --restart always \
                --network host \
                --ulimit nofile=${ULIMIT} \
                -p 443:443 -p 80:80 \
                -e DEBUG=${DEBUG} \
                -e CERT_EMAIL=${CERT_EMAIL} \
                -e ENABLE_CUSTOM_ERROR_PAGE=${ENABLE_CUSTOM_ERROR_PAGE} \
                -v /usr/share/zoneinfo:/usr/share/zoneinfo:ro \
                -v /etc/localtime:/etc/localtime:ro \
                -v ${DCR_VOLUME}/logs:/var/log/nginx/sites \
                -v ${DCR_VOLUME}/letsencrypt:/etc/letsencrypt \
                -v ${DCR_VOLUME}/vhost.d:/etc/nginx/vhost.d \
                -v ${DCR_VOLUME}/stream.d:/etc/nginx/stream.d \
                -v ${DCR_VOLUME}/epage.d:/etc/nginx/epage.d \
                ${DCR_IMAGE}
