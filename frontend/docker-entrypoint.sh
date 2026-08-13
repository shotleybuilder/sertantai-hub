#!/bin/sh
# Generate env-config.js from VITE_* environment variables.
# This lets one Docker image work for any environment — the compose
# file sets the URLs, not the build.
set -e

cat > /app/build/env-config.js << 'HEADER'
window.__ENV__ = {
HEADER

for var in $(env | grep '^VITE_'); do
  key=$(echo "$var" | cut -d '=' -f 1)
  value=$(echo "$var" | cut -d '=' -f 2-)
  echo "  $key: \"$value\"," >> /app/build/env-config.js
done

echo "};" >> /app/build/env-config.js

exec "$@"
