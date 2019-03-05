#!/bin/sh

if [ "$(uname)" == "Darwin" ]; then
    # Running on macOS.
    # Let's assume that the user has the Docker CE installed
    # which doesn't require a root password.
    echo "The preview will be available at http://localhost:8080/"
    docker run --rm -v $(pwd)/public:/usr/share/nginx/html:ro -p 8080:80 nginx

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    if [ -f /usr/bin/podman ]; then
        echo ""
        echo "This preview script is using Podman to run nginx in an isolated environment. You might be asked for a root password in order to start it."
        echo "The preview will be available at http://localhost:8080/"
        echo ""
	    sudo podman run --rm -v $(pwd)/public:/usr/share/nginx/html:ro -p 8080:80 nginx

    elif [ -f /usr/bin/docker ]; then
        echo ""
        echo "This preview script is using Docker to run nginx in an isolated environment. You might be asked for a root password in order to start it."
        echo ""

        if groups | grep -wq "docker"; then
	        docker run --rm -v $(pwd)/public:/usr/share/nginx/html:ro -p 8080:80 nginx
	    else
            echo ""
            echo "The preview will be available at http://localhost:8080/"
            echo "You can avoid this by adding your user to the 'docker' group, but be aware of the security implications. See https://docs.docker.com/install/linux/linux-postinstall/."
            echo ""
            sudo docker run --rm -v $(pwd)/public:/usr/share/nginx/html:ro -p 8080:80 nginx
	    fi

    else
        echo ""
	    echo "Error: Container runtime haven't been found on your system. Fix it by:"
	    echo "$ sudo dnf install podman"
	    exit 1
    fi


fi
