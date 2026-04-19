#!/usr/bin/env bash
# Racing Scoreboard — double-click to launch
# Uses a .venv inside the repo, compatible with Homebrew Python (PEP 668).

cd "$(dirname "$0")"
VENV=".venv"

# ── Find Python 3.10+ ─────────────────────────────────────────────────────────
PYTHON=""
for candidate in \
    /Library/Frameworks/Python.framework/Versions/3.14/bin/python3.14 \
    /Library/Frameworks/Python.framework/Versions/3.13/bin/python3.13 \
    /Library/Frameworks/Python.framework/Versions/3.12/bin/python3.12 \
    /Library/Frameworks/Python.framework/Versions/3.11/bin/python3.11 \
    /Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10 \
    /opt/homebrew/bin/python3.14 \
    /opt/homebrew/bin/python3.13 \
    /opt/homebrew/bin/python3.12 \
    /opt/homebrew/bin/python3.11 \
    /opt/homebrew/bin/python3 \
    /usr/local/bin/python3.14 \
    /usr/local/bin/python3.13 \
    /usr/local/bin/python3.12 \
    /usr/local/bin/python3.11 \
    /usr/local/bin/python3 \
    python3.14 python3.13 python3.12 python3.11 python3.10; do
    if command -v "$candidate" &>/dev/null || [ -x "$candidate" ]; then
        MINOR=$("$candidate" -c "import sys; print(sys.version_info.minor)" 2>/dev/null)
        MAJOR=$("$candidate" -c "import sys; print(sys.version_info.major)" 2>/dev/null)
        if [ "$MAJOR" = "3" ] && [ "${MINOR:-0}" -ge 10 ]; then
            PYTHON="$candidate"
            break
        fi
    fi
done

if [ -z "$PYTHON" ]; then
    echo "ERROR: Python 3.10+ not found. Install from https://www.python.org/downloads/"
    read -rp "Press Enter to close..."; exit 1
fi

echo "Using $PYTHON ($(${PYTHON} --version))"

# ── Create venv if needed ─────────────────────────────────────────────────────
if [ ! -x "$VENV/bin/python" ]; then
    echo "Creating virtual environment (one-time)..."
    "$PYTHON" -m venv "$VENV" || { echo "ERROR: venv creation failed."; read -rp "Press Enter..."; exit 1; }
fi

# ── Install pywebview if missing ──────────────────────────────────────────────
if ! "$VENV/bin/python" -c "import webview" 2>/dev/null; then
    echo "Installing pywebview (one-time, ~5 MB, requires internet)..."
    "$VENV/bin/pip" install pywebview || { echo "ERROR: install failed."; read -rp "Press Enter..."; exit 1; }
    echo "Done!"
fi

exec "$VENV/bin/python" app.py
