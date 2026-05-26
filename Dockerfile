# syntax=docker/dockerfile:1
# Multi-stage: Flutter web build → nginx
#
# Rebuild:
#   docker compose build --no-cache && docker compose up -d --force-recreate
#
# Weak VPS (≤2 GB RAM): in .env set DART2JS_OPTIMIZATION=O1
FROM ghcr.io/cirruslabs/flutter:3.41.5 AS build

ENV CI=true \
    FLUTTER_SUPPRESS_ANALYTICS=true \
    DART_VM_OPTIONS=--old_gen_heap_size=4096

WORKDIR /app

RUN flutter config --enable-web --no-analytics \
    && flutter precache --web \
        --no-android --no-ios --no-linux --no-macos --no-windows

COPY pubspec.yaml pubspec.lock analysis_options.yaml ./

# Fail fast if server repo is outdated
RUN ! grep -q 'flutter_secure_storage' pubspec.yaml pubspec.lock

COPY lib/ lib/
COPY assets/ assets/
COPY web/ web/
COPY scripts/verify-web-build.sh scripts/verify-web-build.sh

ARG API_BASE_URL=http://5.42.113.18:8001
ARG DART2JS_OPTIMIZATION=O1
RUN printf 'API_BASE_URL=%s\n' "$API_BASE_URL" > assets/app.env

# Fresh plugin registrant on every build (no .dart_tool cache mount)
RUN --mount=type=cache,target=/root/.pub-cache \
    rm -rf .dart_tool .flutter-plugins-dependencies build \
    && flutter pub get \
    && flutter build web --release \
        --no-wasm-dry-run \
        --no-web-resources-cdn \
        --dart2js-optimization="${DART2JS_OPTIMIZATION}" \
    && date -u +%Y-%m-%dT%H:%M:%SZ > build/web/build-id.txt \
    && chmod +x scripts/verify-web-build.sh \
    && ./scripts/verify-web-build.sh

FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO- http://127.0.0.1/ > /dev/null || exit 1

CMD ["nginx", "-g", "daemon off;"]
