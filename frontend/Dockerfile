# Build stage
FROM node:16-alpine as build

WORKDIR /app

# Copy package files and npm configuration
COPY package*.json .npmrc ./
COPY tsconfig.json ./

# Install dependencies with specific steps
RUN npm cache clean --force && \
    npm install && \
    npm install ajv@6.12.6 ajv-keywords@3.5.2 schema-utils@3.1.2 --save-exact

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy built assets from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
