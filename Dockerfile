FROM node:18 AS build

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml .npmrc ./

RUN npm install -g pnpm

RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm run build

RUN pnpm prune --prod

FROM node:18-alpine3.19

WORKDIR /usr/src/app

RUN npm install -g pnpm

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["pnpm", "run", "start:prod"]
