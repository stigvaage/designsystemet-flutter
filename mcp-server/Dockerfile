FROM node:18-alpine AS build
WORKDIR /app

# Copy the full repo (needed for build-data to parse Dart sources)
COPY . /repo
WORKDIR /repo/mcp-server

RUN npm ci
RUN npm run build
RUN npm run build-data

FROM node:18-alpine
WORKDIR /app

COPY --from=build /repo/mcp-server/dist ./dist
COPY --from=build /repo/mcp-server/node_modules ./node_modules
COPY --from=build /repo/mcp-server/package.json ./package.json

ENTRYPOINT ["node", "dist/index.js"]
