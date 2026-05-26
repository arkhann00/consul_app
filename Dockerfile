# syntax=docker/dockerfile:1
# Multi-stage: Flutter web build → nginx
#
# Rebuild & restart:
#   docker compose up -d --build --force-recreate
#
# Auto-rebuild on file changes (dev on server):
#   docker compose watch
#
# Requires BuildKit (default in Docker Desktop / Docker 23+):
#   DOCKER_BUILDKIT=1
FROM ghcr.io/cirruslabs/flutter:3.41.5 AS build

ENV CI=true \
    FLUTTER_SUPPRESS_ANALYTICS=true \
    DART_VM_OPTIONS=--old_gen_heap_size=4096

WORKDIR /app

RUN flutter config --enable-web --no-analytics \
    && flutter precache --web \
        --no-android --no-ios --no-linux --no-macos --no-windows

# Dependencies layer — rebuilds only when pubspec changes
COPY pubspec.yaml pubspec.lock analysis_options.yaml ./
RUN --mount=type=cache,target=/root/.pub-cache \
    flutter pub get

# App sources — dart2js is CPU-heavy; expect 3–10+ min on small VPS
COPY lib/ lib/
COPY assets/ assets/
COPY web/ web/

ARG API_BASE_URL=http://5.42.113.18:8001
ARG DART2JS_OPTIMIZATION=O4
RUN printf 'API_BASE_URL=%s\n' "$API_BASE_URL" > assets/app.env

# Do not cache .dart_tool — stale web_plugin_registrant breaks builds after dependency changes
RUN --mount=type=cache,target=/root/.pub-cache \
    flutter clean \
    && flutter pub get \
    && flutter build web --release \
        --no-wasm-dry-run \
        --no-web-resources-cdn \
        --dart2js-optimization="${DART2JS_OPTIMIZATION}" \
    && date -u +%Y-%m-%dT%H:%M:%SZ > build/web/build-id.txt \
    && grep -q 'access_token' build/web/main.dart.js \
    && ! grep -q 'generateKey' build/web/main.dart.js \
    && ! grep -q 'FlutterSecureStorage' build/web/main.dart.js

# Stage 2: serve static files
FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO- http://127.0.0.1/ > /dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]
