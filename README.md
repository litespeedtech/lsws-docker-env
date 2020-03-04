# LiteSpeed WordPress Docker Container (Beta)
[![Build Status](https://travis-ci.com/litespeedtech/lsws-docker-env.svg?branch=master)](https://hub.docker.com/r/litespeedtech/litespeed)
[![LiteSpeed](https://img.shields.io/badge/litespeed-5.4.5-informational?style=flat&color=blue)](https://hub.docker.com/r/litespeedtech/litespeed)
[![docker pulls](https://img.shields.io/docker/pulls/litespeedtech/litespeed?style=flat&color=blue)](https://hub.docker.com/r/litespeedtech/litespeed)
[![beta pulls](https://img.shields.io/docker/pulls/litespeedtech/litespeed-beta?label=beta%20pulls)](https://hub.docker.com/r/litespeedtech/litespeed-beta)

Install a Lightweight WordPress container with LiteSpeed 5.4.5+ & PHP 7.3+ based on Ubuntu 18.04 Linux.

### Prerequisites
1. [Install Docker](https://www.docker.com/)
2. [Install Docker Compose](https://docs.docker.com/compose/)
3. Clone this repository or copy the files from this repository into a new folder:
```
git clone https://github.com/litespeedtech/lsws-docker-env.git
```

## Configuration
Edit the `.env` file to update the demo site domain, default MySQL user, and password.

## Installation
Open a terminal, `cd` to the folder in which `docker-compose.yml` is saved, and run:
```
docker-compose up
```

## Components
The docker image installs the following packages on your system:

|Component|Version|
| :-------------: | :-------------: |
|Linux|Ubuntu 18.04|
|LiteSpeed|[Latest version](https://www.litespeedtech.com/products/litespeed-web-server/download)|
|MariaDB|[Stable version: 10.3](https://hub.docker.com/_/mariadb)|
|PHP|[Stable version: 7.3](http://rpms.litespeedtech.com/debian/)|
|LiteSpeed Cache|[Latest from WordPress.org](https://wordpress.org/plugins/litespeed-cache/)|
|Certbot|[Latest from Certbot's PPA](https://launchpad.net/~certbot/+archive/ubuntu/certbot)|
|WordPress|[Latest from WordPress](https://wordpress.org/download/)|
|phpMyAdmin|[Latest from dockerhub](https://hub.docker.com/r/bitnami/phpmyadmin/)|

## Data Structure
There is a `sites` directory next to your `docker-compose.yml` file, and it contains the following:

* `sites/DOMAIN/html/` – Document root (the WordPress application will install here)
* `sites/DOMAIN/logs/` - Access log storage

## Usage
### Starting a Container
Start the container with the `up` or `start` methods:
```
docker-compose up
```
You can run with daemon mode, like so:
```
docker-compose up -d
```
The container is now built and running. 

### Stopping a Container
```
docker-compose stop
```
### Removing Containers
To stop and remove all containers, use the `down` command:
```
docker-compose down
```
### Installing Packages
Edit the `docker-compose.yml` file, and add the package name as an `extensions` argument. We used `vim` in this example:
```
litespeed:
  build:
    context: ./config/litespeed/xxx/
    args:
      extensions: vim
```
After saving the changed configuration, run with `--build`:
```
docker-compose up --build
```

### Setting the WebAdmin Password
We strongly recommend you set your personal password right away.
```
bash bin/webadmin.sh my_password
```
### Starting a Demo Site
After running the following command, you should be able to access the WordPress installation with the configured domain. By default the domain is http://localhost.
```
bash bin/demosite.sh
```
### Creating a Domain and Virtual Host
```
bash bin/domain.sh [-A, --add] example.com
```
### Deleting a Domain and Virtual Host
```
bash bin/domain.sh [-D, --del] example.com
```
### Creating a Database
You can either automatically generate the user, password, and database names, or specify them. Use the following to auto generate:
```
bash bin/database.sh [-D, --domain] example.com
```
Use this command to specify your own names, substituting `user_name`, `my_password`, and `database_name` with your preferred values:
```
bash bin/database.sh [-D, --domain] example.com [-U, --user] USER_NAME [-P, --password] MY_PASS [-DB, --database] DATABASE_NAME
```
### Installing a WordPress Site
To preconfigure the `wp-config` file, run the `database.sh` script for your domain, before you use the following command to install WordPress:
```
./bin/appinstall.sh [-A, --app] wordpress [-D, --domain] example.com
```
### Install ACME 
We need to run the ACME installation command the **first time only**. 
With email notification:
```
./bin/acme.sh [-I, --install] [-E, --email] EMAIL_ADDR
```
Without email notification:
```
./bin/acme.sh [-I, --install] [-NE, --no-email]
```
### Applying a Let's Encrypt Certificate
Use the root domain in this command, and it will check for a certificate and automatically apply one with and without `www`:
```
./bin/acme.sh [-D, --domain] example.com
```
### Update Web Server
To upgrade the web server to latest stable version, run the following:
```
bash bin/webadmin.sh [-U, --upgrade]
```
### Apply OWASP ModSecurity
Enable OWASP `mod_secure` on the web server: 
```
bash bin/webadmin.sh [-M, --mod-secure] enable
```
Disable OWASP `mod_secure` on the web server: 
```
bash bin/webadmin.sh [-M, --mod-secure] disable
```

### Apply license to LSWS
Apply your license with command:
```
bash bin/webadmin.sh [-S, --serial] YOUR_SERIAL
```
Apply trial license to server with command:
```
bash bin/webadmin.sh [-S, --serial] TRIAL
```

### Accessing the Database
After installation, you can use phpMinAdmin to access the database by visiting http://127.0.0.1:8080 or https://127.0.0.1:8443. The default username is `root`, and the password is the same as the one you supplied in the `.env` file.

## Support & Feedback
If you still have a question after using LiteSpeed Docker, you have a few options.
* Join [the GoLiteSpeed Slack community](litespeedtech.com/slack) for real-time discussion
* Post to [the LiteSpeed Forums](https://www.litespeedtech.com/support/forum/) for community support
* Reporting any issue on [Github lsws-docker-env](https://github.com/litespeedtech/lsws-docker-env/issues) project

**Pull requests are always welcome**