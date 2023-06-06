# build-nap-container

The NGINX+ image will be build based on a trial license. To get a free trial apply under:

https://www.nginx.com/free-trial-request

For reference check the official NGINX docs:

https://docs.nginx.com/nginx-app-protect/admin-guide/#docker-deployment

Preparations:
---------------

Platform: In this case Ubuntu 18.04 Server VM.

ssh to VM:

Make docker command run withoput sudo

    $ sudo groupadd docker

    $ sudo usermod -aG docker $USER

Log out and log back in so that your group membership is re-evaluated.
If testing on a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

Verify

    $ docker ps      #should work without sudo

Build Nginx+ Container with App Protect included
--

1. Initial build

        $ git clone https://github.com/dfs5/build-nap-container.git

        $ cd build-nap-container

Create nginx-repo.crt and nginx-repo.key files to access your nginx repository!!! 

    $ DOCKER_BUILDKIT=1 docker build --no-cache --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key -t app-protect .

Verify that a new 'app-protect:latest' image has been created: 

    $ docker images

2. Update SIGnatures and Threat Campaigns (TC)

        $ docker build --no-cache -t app-protect -f NAPupdateSIG-TC .

In log output watch out for signature update entries similar to: 
- 'app-protect-attack-signatures amd64 2020.11.12-1~bionic'
- 'app-protect-threat-campaigns amd64 2020.11.11-1~bionic'

Also verify that 'app-protect' image has a new image id.

    $ docker images      #image app-protect has a new image id

3. Run the new image to verify the NAP plugin is running.

        $ docker run --name my-app-protect -p 80:80 -d app-protect

Verify App Protect processes (bd_agent, bd-socket-plugin, nginx: master process, nginx: worker) process are running. https://docs.nginx.com/nginx-app-protect/admin-guide/#post-installation-checks

    $ docker exec -it my-app-protect ps aux

or:

    $ docker exec -it my-app-protect bash

    $ ps aux

4. Check the NGINX binary version and default configuration

        $ docker exec my-app-protect nginx -v

        $ docker exec my-app-protect nginx -T

5. Optional if you want to use the convertaer tool. Create a temporary folder and copy your XML policy file(s) to it:

        $ mkdir /tmp/converter
    
        $ cp policy.xml /tmp/converter/
      
And run the docker image with the temporary folder as a mounted volume on the container, and run the policy converter script:

    $ docker run -v /tmp/convert:/tmp/convert app-protect-converter /opt/app_protect/bin/convert-policy -i /tmp/convert/policy.xml -o /tmp/convert/policy.json | jq

You are done with the first part!!!
--

You can stop and clean the container and follow with nap-demo to see NAP in action: 

https://github.com/dfs5/nap-demo

& docker stop my-app-protect

& docker rm my-app-protect
