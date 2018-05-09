# DevOps-AutomateBash

## About
DevOps-AutomateBash is a script that helps deploy a project from github, install and setup all necessary requirement on `amazon linux instance`

#### Dependencies

1. These project uses [`pm2`](http://pm2.keymetrics.io/) for running the application in background process
2.  [`nginx`](https://www.nginx.com/) for reverse proxy

#### Instructions

You can get the script running in the following way:

1. Install git on your instance by running
   ```
   sudo yum install git
   ```

2. Clone the repository and cd into it
   
	  ```
    git clone https://github.com/kensanni/DevOps-AutomateBash.git
    cd DevOps-AutomateBash
    ```
3. To run the script without generating `SSL certificate`, run
    ```
    bash noSSl.sh
    ```
4. To generate `SSL certificate` for your domain with these script, run
    ```
    bash setup.sh
    ```
5.  Note that the port for the application is set to 8000
