# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Avoid interactive prompts during apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install dependencies
RUN apt-get update && \
    apt-get install -y fortune-mod cowsay netcat-openbsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add games directory to PATH (where fortune and cowsay are installed)
ENV PATH="/usr/games:${PATH}"

# Verify installations work
RUN /usr/games/fortune | /usr/games/cowsay

# Set working directory
WORKDIR /app

# Copy the wisecow script into container
COPY wisecow.sh /app/wisecow.sh

# Make script executable
RUN chmod +x /app/wisecow.sh

# Expose the port your script listens on
EXPOSE 4499

# Run script
CMD ["/app/wisecow.sh"]