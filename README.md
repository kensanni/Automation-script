# DevOps-AutomateBash

## About
DevOps-AutomateBash is a script that helps deploy a project from github, install and setup all necessary requirement on `Ubuntu server`

#### Dependencies

1. These project uses [`pm2`](http://pm2.keymetrics.io/) for running the application in background process
2.  [`nginx`](https://www.nginx.com/) for reverse proxy
3.  [`Certbot`](https://github.com/certbot/certbot) for enabling letEncrypt SSL certificates

#### Security Group
>- When creating your instance set the security group to the following below:
>- set `type`:`HTTP` to `source` of `Anywhere`
>- set `type`:`HTTPS` to `source` of `Anywhere`
>- set `type`:`Custom TCP` to `port`:8000 of `source`: `MY IP`
>- set `type`:`SSH` to `source` of `MY IP`


#### Instructions

You can get the script running in the following way:

1. Clone the repository and cd into it
   
	  ```
    git clone https://github.com/kensanni/DevOps-AutomateBash.git
    cd DevOps-AutomateBash
    ```
2. To run the script, run
    ```
    bash ubun.sh
    ```
4. To generate `SSL certificate` for your domain with these script, run
    ```
    bash setup.sh
    ```
5.  Note that the port for the application is set to 8000
