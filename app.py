#!/usr/bin/env python3
"""Racing Scoreboard — native macOS app (requires: pip install pywebview)"""

import os
import socket
import threading
from http.server import HTTPServer, SimpleHTTPRequestHandler
import webview


def _find_port(start: int = 8765) -> int:
    port = start
    while True:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            if s.connect_ex(('127.0.0.1', port)) != 0:
                return port
        port += 1


class _QuietHandler(SimpleHTTPRequestHandler):
    def log_message(self, *args):
        pass


def _serve(directory: str, port: int) -> None:
    os.chdir(directory)
    with HTTPServer(('127.0.0.1', port), _QuietHandler) as httpd:
        httpd.serve_forever()


def main():
    repo_dir = os.path.dirname(os.path.abspath(__file__))
    port = _find_port()

    t = threading.Thread(target=_serve, args=(repo_dir, port), daemon=True)
    t.start()

    webview.create_window(
        title='Racing Scoreboard',
        url=f'http://127.0.0.1:{port}/launcher.html',
        width=1280,
        height=820,
        min_size=(900, 600),
        resizable=True,
    )
    webview.start()


if __name__ == '__main__':
    main()
