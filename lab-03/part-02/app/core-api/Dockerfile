# Stage 1: Build/Dependency stage
FROM node:20-alpine AS builder
WORKDIR /app

# Initialize a clean package context and install express directly
RUN npm init -y && npm install express

# Copy application source files and frontend assets
COPY server.js ./
COPY public ./public

# Stage 2: Minimal Production environment using alpine
FROM node:20-alpine
WORKDIR /app

# Pull the installed dependencies, engine, and UI assets from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/server.js ./
COPY --from=builder /app/public ./public

EXPOSE 8080
CMD ["node", "server.js"]
