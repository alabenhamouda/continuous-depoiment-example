# Stage 1: Build and package the application
FROM node:18 AS builder

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

# Install app dependencies
RUN npm install

# Bundle app source
COPY . .

# Build the app
RUN npm run build

# Stage 2: Create a smaller image for production
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy only the built artifacts and production dependencies from the previous stage
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/package.json ./

# Expose the port on which the app will run
EXPOSE 80

# Start the server using the production build
CMD ["npm", "run", "start:prod"]
