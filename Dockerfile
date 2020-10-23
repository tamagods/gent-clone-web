FROM node:13.8.0-alpine as base
ARG environment
ENV environment $environment
WORKDIR /app

FROM base as download
ENV PATH /app/node_modules/.bin:$PATH
COPY package*.json /app/
RUN yarn install
COPY . /app

FROM download as builder
RUN yarn run build

FROM nginx:1.16.0-alpine
RUN mkdir /app
COPY --from=builder /app/dist /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
