# Dockerfile for backend
FROM node:16

# Install curl to download wait-for-it
RUN apt-get update && apt-get install -y curl

# Download wait-for-it script
RUN curl -o /usr/local/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x /usr/local/bin/wait-for-it.sh

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .


# Install dependencies
RUN npm install

# Start the application, waiting for MySQL to be ready
CMD /usr/local/bin/wait-for-it.sh mysql-container:3306 -- npm start
