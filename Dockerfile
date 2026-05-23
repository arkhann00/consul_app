# Stage 1: build Flutter web
FROM ghcr.io/cirruslabs/flutter:3.41.5 AS build

ENV CI=true \
    FLUTTER_SUPPRESS_ANALYTICS=true \
    DART_VM_OPTIONS=--old_gen_heap_size=4096

WORKDIR /app

RUN flutter config --enable-web --no-analytics \
    && flutter precache --web \
        --no-android --no-ios --no-linux --no-macos --no-windows

# Only app sources — avoids stale host build artifacts in the image context
COPY pubspec.yaml pubspec.lock analysis_options.yaml ./
COPY lib/ lib/
COPY assets/ assets/
COPY web/ web/

RUN flutter pub get

ARG API_BASE_URL=http://5.42.113.18:8001
RUN printf 'API_BASE_URL=%s\n' "$API_BASE_URL" > assets/app.env

RUN flutter clean \
    && flutter pub get \
    && flutter build web --release \
        --no-wasm-dry-run \
        --no-web-resources-cdn \
        -v

# Stage 2: serve static files
FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
