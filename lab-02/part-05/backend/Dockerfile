FROM node:18-alpine
WORKDIR /app
# RUN npm install
COPY server.js . 
# Install dependencies directly
RUN npm install express cors
EXPOSE 3000
CMD ["node", "server.js"]