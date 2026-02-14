echo "Executing Clean Build"

if [ $# -eq 0 ]; then
  echo "Error: Please provide the Godot version as an argument."
  exit 1
fi

CURRENT_GODOT_VERSION="$1"

./scripts/download_godot.sh ${CURRENT_GODOT_VERSION}
./scripts/generate_headers.sh || true
./scripts/release_static_library.sh ${CURRENT_GODOT_VERSION}