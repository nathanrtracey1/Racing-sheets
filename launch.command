#!/usr/bin/env bash
# Racing Scoreboard — double-click to launch
# Requires Python 3.10+ from python.org or Homebrew.
# The built-in macOS Python 3.9 (Xcode CLT) is NOT compatible.

cd "$(dirname "$0")"

# ── Find Python 3.10+ ─────────────────────────────────────────────────────────
PYTHON=""
for candidate in \
    /Library/Frameworks/Python.framework/Versions/3.13/bin/python3.13 \
    /Library/Frameworks/Python.framework/Versions/3.12/bin/python3.12 \
    /Library/Frameworks/Python.framework/Versions/3.11/bin/python3.11 \
    /Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10 \
    /opt/homebrew/bin/python3.13 \
    /opt/homebrew/bin/python3.12 \
    /opt/homebrew/bin/python3.11 \
    /opt/homebrew/bin/python3 \
    /usr/local/bin/python3.13 \
    /usr/local/bin/python3.12 \
    /usr/local/bin/python3.11 \
    /usr/local/bin/python3 \
    python3.13 python3.12 python3.11 python3.10; do
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
    echo ""
    echo "ERROR: Python 3.10 or newer is required."
    echo "Your system Python is 3.9 (too old for pywebview)."
    echo ""
    echo "Fix: Download Python 3.12 from https://www.python.org/downloads/"
    echo "     Install it, then run this file again."
    echo ""
    read -rp "Press Enter to close..."
    exit 1
fi

echo "Using $PYTHON ($(${PYTHON} --version))"

# ── Install pywebview if missing ──────────────────────────────────────────────
if ! "$PYTHON" -c "import webview" 2>/dev/null; then
    echo "Installing pywebview (one-time setup, ~5 MB, requires internet)..."
    "$PYTHON" -m pip install pywebview --user || {
        echo ""
        echo "ERROR: Install failed. Try: $PYTHON -m pip install pywebview"
        read -rp "Press Enter to close..."
        exit 1
    }
    echo "Done!"
fi

exec "$PYTHON" app.py
