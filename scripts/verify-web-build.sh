#!/bin/sh
set -eu

JS=build/web/main.dart.js

if [ ! -f "$JS" ]; then
  echo "ERROR: $JS not found — flutter build web failed"
  exit 1
fi

if grep -q 'FlutterSecureStorageWeb' "$JS"; then
  echo "ERROR: flutter_secure_storage is still bundled (old plugin registrant)"
  exit 1
fi

if ! grep -q 'saveTokens' "$JS"; then
  echo "ERROR: auth saveTokens not found in bundle"
  exit 1
fi

echo "OK: web build verified ($(wc -c < "$JS") bytes)"
