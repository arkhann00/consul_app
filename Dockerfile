# Stage 1: build Flutter web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# API URL is baked into the web bundle via assets/app.env
ARG API_BASE_URL=http://5.42.113.18:8001
RUN printf 'API_BASE_URL=%s\n' "$API_BASE_URL" > assets/app.env

RUN flutter build web --release

# Stage 2: serve static files
FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
