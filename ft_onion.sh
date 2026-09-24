#!/bin/bash

# Simple ft_onion management

CONTAINER_NAME="ft_onion_container"
IMAGE_NAME="ft_onion"

case "$1" in
    status)
        if docker ps -q -f name=$CONTAINER_NAME; then
            echo "Running - Web: http://localhost:8080"
            WEB_ONION=$(docker exec $CONTAINER_NAME cat /var/lib/tor/hidden_service/hostname 2>/dev/null || echo "Not ready")
            SSH_ONION=$(docker exec $CONTAINER_NAME cat /var/lib/tor/hidden_ssh/hostname 2>/dev/null || echo "Not ready")
            echo "Web Onion: $WEB_ONION"
            echo "SSH Onion: $SSH_ONION"
        else
            echo "Not running"
        fi
        ;;
    
    start)
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        docker build -t $IMAGE_NAME .
        docker run -d --name $CONTAINER_NAME -p 8080:80 -p 2222:4242 $IMAGE_NAME
        sleep 3
        $0 status
        ;;
    
    stop)
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
        ;;
    
    restart)
        $0 stop
        $0 start
        ;;
    
    logs)
        docker logs $CONTAINER_NAME
        ;;
    
    ssh)
        ssh -o StrictHostKeyChecking=no -p 2222 aareslan@localhost
        ;;
    
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|ssh}"
        ;;
esac
