FROM node:18-alpine

# Install git and curl
RUN apk add --no-cache git curl bash

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3001

CMD ["npm", "start"]
