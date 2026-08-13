################################################################################
# Builder Stage
################################################################################
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (npm install tolerates platform-specific optional deps
# in the lockfile that don't match the Docker build platform)
RUN npm install

# Copy application code
COPY . .

# Build the SvelteKit application
RUN npm run build

################################################################################
# Runner Stage
################################################################################
FROM node:20-alpine

# Install production dependencies for serving
RUN npm install -g serve@14

WORKDIR /app

# Copy built assets from builder
COPY --from=builder /app/build ./build

# Copy entrypoint script (generates env-config.js from VITE_* env vars at startup)
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Use the existing non-root 'node' user (uid/gid 1000 in node:alpine)
RUN chown -R node:node /app

USER node

EXPOSE 3000

# Health check - serve has built-in health at root
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

# Entrypoint injects VITE_* env vars into env-config.js, then runs serve
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["serve", "-s", "build", "-l", "3000", "--no-request-logging"]
