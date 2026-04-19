#!/usr/bin/env bash
# Racing Scoreboard — double-click to launch
# This opens the scoreboard in your default browser.
# Close this Terminal window to stop the server.

cd "$(dirname "$0")"

PORT=8765
while lsof -Pi :"$PORT" -sTCP:LISTEN -t >/dev/null 2>&1; do
  PORT=$((PORT + 1))
done

echo "Starting Racing Scoreboard on port $PORT..."
python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null' EXIT

sleep 0.6
open "http://127.0.0.1:$PORT/launcher.html"

echo "Scoreboard running at http://127.0.0.1:$PORT/launcher.html"
echo "Close this window to stop."

wait "$SERVER_PID"
