# Use a lightweight Node.js image
FROM node:18-slim

# Set the working directory
WORKDIR /app

# Copy the backend code
COPY server.js .

# Install the modules
RUN npm init -y && npm install express cors

# Expose the port your app will run on
EXPOSE 3000

CMD ["node", "server.js"]