# Stage 1: Build/Dependency stage
FROM node:20-alpine AS builder
WORKDIR /app
# Copy package files
COPY server.js ./

# Stage 2: Minimal Production environment using alpine
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/server.js ./

EXPOSE 8080
CMD ["node", "server.js"]

