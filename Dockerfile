# Step 1: Start from official Ubuntu base image
FROM ubuntu:22.04

# Step 2: Avoid interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Step 3: Install all dependencies the app needs
RUN apt-get update && apt-get install -y \
    cowsay \
    fortune \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Step 4: cowsay installs to /usr/games, add it to PATH
ENV PATH="/usr/games:${PATH}"

# Step 5: Set working directory inside the container
WORKDIR /app

# Step 6: Copy the app script into the container
COPY wisecow.sh .

# Step 7: Make the script executable
RUN chmod +x wisecow.sh

# Step 8: Tell Docker this container listens on port 4499
EXPOSE 4499

# Step 9: Run the app when container starts
CMD ["bash", "wisecow.sh"]
