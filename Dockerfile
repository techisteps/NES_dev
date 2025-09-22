# Use the official Alpine Linux image as the base
FROM alpine:latest

# Update the package index and install a few common packages
# --no-cache reduces image size by not storing package index locally
RUN apk update && apk add --no-cache \
    bash \
    git \
#    curl \
	build-base \
    nano

RUN git clone https://github.com/cc65/cc65.git && cd cc65 && make && make avail

RUN mkdir /root/nes

RUN addgroup nesuser && adduser -h /home/nesuser -G nesuser -D nesuser -s /bin/bash && echo "nesuser:your_password" | chpasswd

# Set the default command to run when the container starts
CMD ["bash"]