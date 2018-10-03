# Install Docker on Ubuntu 16.04

Taken from
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04

## If you install the '/etc' files on Ubuntu <=17 pay attentions at `/etc/systemd/system/docker.*` files

~~~bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

~~~

~~~bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
~~~

~~~bash
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
~~~

~~~bash
sudo apt-get update
~~~

~~~bash
apt-cache policy docker-ce
~~~

~~~bash
sudo apt-get install -y docker-ce
~~~

~~~bash
sudo systemctl status docker
~~~

~~~bash
sudo usermod -aG docker ${USER}
~~~

~~~bash
su - ${USER}
~~~

~~~bash
id -nG
~~~


