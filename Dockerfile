# Use Node.js 22 base image
FROM node:22-alpine

# Install pm2 globally
RUN npm install -g pm2

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first (for caching npm install layer)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose application port
EXPOSE 3000

# Start application using pm2
CMD ["pm2-runtime", "src/server.js", "--name", "node-app"]
