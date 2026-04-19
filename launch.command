#!/usr/bin/env bash
# Racing Scoreboard — double-click to launch
# Requires Python 3. Close this window to quit.

cd "$(dirname "$0")"

if ! command -v python3 &>/dev/null; then
    echo "ERROR: Python 3 not found. Install from python.org or: brew install python3"
    read -rp "Press Enter to close..."
    exit 1
fi

if ! python3 -c "import webview" 2>/dev/null; then
    echo "Installing pywebview (one-time setup, ~5 MB, requires internet)..."
    python3 -m pip install pywebview --user || {
        echo ""
        echo "ERROR: Install failed. Try manually: pip3 install pywebview"
        read -rp "Press Enter to close..."
        exit 1
    }
    echo "Done! Launching..."
fi

exec python3 app.py
