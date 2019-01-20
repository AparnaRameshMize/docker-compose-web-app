# Use an official python image (Ref: https://hub.docker.com/_/python)
# Refer to the Dockerfile of the base image (Ref: https://github.com/docker-library/python/blob/39c500cc8aefcb67a76d518d789441ef85fc771f/2.7/stretch/slim/Dockerfile)
FROM python:2.7-slim

# Create a folder for app code
# RUN - to run linux command (since python:2.7-slim is Linux based)
RUN mkdir /app

# set the context path for further
WORKDIR /app

# COPY - takes src and destination. requirements.txt will be copied to /app
COPY requirements.txt requirements.txt

# Install python depepndencies specified in requirements.txt
RUN pip install -r requirements.txt

# Copy recursively all the content from the directory (that has the Dockerfile) and below
COPY . .

## Notice that the 'requirements.txt' file is copied, followed by installing the dependencies.
## Later all the cntents of the current directory (that also includes 'requirements.txt') are copied.
## This is deliberate to create a Layer that has all the dependencies and another Layer that has all the code artifcats - this will ensure that the cached dependencies layer is used each time an image is built with only the code changes (more common). The dependencies layer is only built when there is change in the Python dependencies, as specified in the 'requirements.txt' file.

# Use LABEL to attach metadata to the image
LABEL version="2.0"


VOLUME ["/app/public"]

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# ENTRYPOINT instruction allows the execution of a script after the docker container starts
ENTRYPOINT ["/docker-entrypoint.sh"]

# CMD - the default command that will run when the container get started
# RUN gets executed when the image is built vs CMD get executed when the comtainer is started
CMD flask run --host=0.0.0.0 --port=5000
