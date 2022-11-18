FROM node:18.12.0

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

EXPOSE 8080

CMD ["npm", "run", "start"]
