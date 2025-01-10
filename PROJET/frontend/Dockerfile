# Use the official Node.js 18 image
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the app with environment variables
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL
RUN npm run build

# Use an nginx server to serve the frontend
FROM nginx:stable-alpine
COPY --from=0 /app/build /usr/share/nginx/html

# Expose the port nginx will serve on
EXPOSE 80

# Start the nginx server
CMD ["nginx", "-g", "daemon off;"]
