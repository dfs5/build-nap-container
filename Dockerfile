# For Ubuntu 18.04:
FROM ubuntu:bionic

# Download certificate and key from the customer portal (https://cs.nginx.com)
# and copy to the build context:
COPY nginx-repo.crt nginx-repo.key /etc/ssl/nginx/

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Download and add the NGINX signing key:
RUN wget https://cs.nginx.com/static/keys/nginx_signing.key && apt-key add nginx_signing.key

# Add NGINX Plus repository:
RUN printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90nginx

# Update the repository and install the most recent version of the NGINX Plus App Protect package (which includes NGINX Plus):
RUN apt-get update && apt-get install -y app-protect

# Remove nginx repository key/cert from docker
RUN rm -rf /etc/ssl/nginx

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY nginx.conf /etc/nginx/
COPY entrypoint.sh  /root/

CMD ["sh", "/root/entrypoint.sh"]


# dfs:

# based on: https://docs.nginx.com/nginx-app-protect/admin-guide/#ubuntu-18-04-docker-deployment-example

# Create a Docker image:
# For CentOS/Debian/Ubuntu:
# sudo docker build --no-cache -t app-protect .

# Create a container based on this image, for example, my-app-protect container:
# sudo docker run --name my-app-protect -p 80:80 -d app-protect

# Check the NGINX binary version to ensure that you have NGINX Plus installed correctly:
# sudo docker exec my-app-protect nginx -v

# Check the nginx.conf:
# sudo docker exec my-app-protect nginx -T

# Check that the four processes (bd_agent, bd-socket-plugin, nginx: master process, nginx: worker process) needed for NGINX App Protect are running:
# sudo docker exec my-app-protect ps aux

# View logfiles
# sudo docker exec my-app-protect ls -lha /var/log/nginx/
