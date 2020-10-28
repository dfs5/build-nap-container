# build-nap-container

Preparations

Install Demo-host. In this case it is Ubuntu 18.04 Server.

Setup pub key auth to the Demo-host:

>> ssh-keygen

>> ssh-copy-id -i ~/.ssh/mykey user@host


ssh to Demo-host:

Create the docker group.
>> sudo groupadd docker

Add your user to the docker group.
>> sudo usermod -aG docker $USER

Log out and log back in so that your group membership is re-evaluated.
If testing on a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

Verify
docker ps #      should work without sudo

1. Build Nginx+ Container with App Protect included

>> cd build-nap-container

>> docker images

>> docker build --no-cache -t app-protect .

>> docker images     #new image app-protect:latest is created
