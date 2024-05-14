FROM node:22-alpine AS base
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app
COPY package*.json ./

FROM base as test
WORKDIR /home/node/app
USER node
ENV NODE_ENV=test
COPY --chown=node:node . .
RUN npm install && npm test

FROM base as production
WORKDIR /home/node/app
USER node
ENV NODE_ENV=production
COPY --chown=node:node . .
RUN npm install
EXPOSE 8080
CMD [ "node", "app.js" ]
