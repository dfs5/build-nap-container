# build-nap-container

For reference check the official NGINX docs:

https://docs.nginx.com/nginx-app-protect/admin-guide/#docker-deployment

Preparations:

Platform: In this case Ubuntu 18.04 Server.

ssh to Demo-host:

Make docker command run withoput sudo

>> sudo groupadd docker

>> sudo usermod -aG docker $USER

Log out and log back in so that your group membership is re-evaluated.
If testing on a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

Verify

>> docker ps      #should work without sudo

1. Build Nginx+ Container with App Protect included

>> git clone https://github.com/dfs5/build-nap-container.git

>> cd build-nap-container

Create nginx-repo.crt and nginx-repo.key files to access your nginx repository!!! 

>> docker images

>> docker build --no-cache -t app-protect .

>> docker images     #new image app-protect:latest is created

2. Update SIG and TC

>> docker build --no-cache -t app-protect -f NAPupdateSIG-TC .

>> docker images      #image app-protect has a new image id

Run the new image

>> docker run --name my-app-protect -p 80:80 -d app-protect

Verify App Protect processes (bd_agent, bd-socket-plugin, nginx: master process, nginx: worker) process are running. https://docs.nginx.com/nginx-app-protect/admin-guide/#post-installation-checks

>> docker exec -it my-app-protect ps aux

You are done with this part!!!

You can stop and clean the container and follow with nap-demo if you like: 

https://github.com/dfs5/nap-demo

>> docker stop my-app-protect

>> docker rm my-app-protect
