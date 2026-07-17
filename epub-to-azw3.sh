#!/usr/bin/env bash
set -euo pipefail

CONTAINER="${EPUB_CONTAINER:-epub-to-azw3}"

usage() {
  cat >&2 <<EOF
Usage: $0 start [dir]
       $0 convert <file.epub>
       $0 stop
EOF
}

calibre_start() {
  local dir
  dir="$(cd "${1:-$PWD}" 2>/dev/null && pwd)" || {
    echo "Not a directory: ${1:-$PWD}" >&2; return 1
  }

  if podman container exists "$CONTAINER"; then
    echo "Container '$CONTAINER' already exists. Run '$0 stop' first." >&2
    return 1
  fi

  podman run -d --name "$CONTAINER" \
    -e PUID="${PUID:-1000}" \
    -e PGID="${PGID:-1000}" \
    -e TZ="${TZ:-Etc/UTC}" \
    -e DOCKER_MODS=linuxserver/mods:universal-calibre \
    -v "$dir":/work:Z \
    lscr.io/linuxserver/calibre-web:latest

  echo "Started '$CONTAINER' with $dir mounted at /work."
  echo "The calibre mod installs in the background; 'convert' will wait for it."
}

calibre_convert() {
  local epub="$1"

  [[ -f "$epub" ]] || { echo "EPUB not found: $epub" >&2; return 1; }

  if [[ "$(podman inspect -f '{{.State.Running}}' "$CONTAINER" 2>/dev/null)" != "true" ]]; then
    echo "Container '$CONTAINER' is not running. Run '$0 start' first." >&2
    return 1
  fi

  local source epub_abs rel
  source="$(podman inspect -f '{{ range .Mounts }}{{ if eq .Destination "/work" }}{{ .Source }}{{ end }}{{ end }}' "$CONTAINER")"
  epub_abs="$(cd "$(dirname "$epub")" && pwd)/$(basename "$epub")"

  case "$epub_abs" in
    "$source"/*) rel="${epub_abs#"$source"/}" ;;
    *) echo "File is outside the mounted directory ($source): $epub_abs" >&2; return 1 ;;
  esac

  local rel_base rel_azw3
  rel_base="${rel%.epub}"
  rel_azw3="${rel_base}.azw3"

  echo "Waiting for ebook-convert to become available..."
  local i
  for ((i = 0; i < 120; i++)); do
    if podman exec "$CONTAINER" sh -c 'command -v ebook-convert >/dev/null 2>&1'; then
      break
    fi
    sleep 1
  done
  if ! podman exec "$CONTAINER" sh -c 'command -v ebook-convert >/dev/null 2>&1'; then
    echo "ebook-convert is not available after waiting; the calibre mod may have failed to install." >&2
    return 1
  fi

  podman exec "$CONTAINER" ebook-convert "/work/$rel_base.epub" "/work/$rel_azw3"
}

calibre_stop() {
  podman rm -f "$CONTAINER" 2>/dev/null || true
  echo "Removed '$CONTAINER'."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  cmd="${1:-}"
  shift || true
  case "$cmd" in
    start)   calibre_start "$@" ;;
    convert)
      [[ $# -eq 1 ]] || { usage; exit 2; }
      calibre_convert "$1"
      ;;
    stop)    calibre_stop ;;
    *)       usage; exit 2 ;;
  esac
fi
