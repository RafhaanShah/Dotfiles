#!/usr/bin/env python3

import curses
import subprocess
import logging
import time

WIFI_PASSWORD = "YOUR-WIFI-WIFI_PASSWORD-HERE"

logging.basicConfig(
    filename="/tmp/remote.log",
    level=logging.DEBUG,
    format="%(asctime)s - %(levelname)s - %(message)s",
)


def adb_keyevent(key_code):
    try:
        subprocess.run(["adb", "shell", f"input keyevent {key_code}"], check=True)
        logging.debug(f"ADB command sent: {key_code}")
    except subprocess.CalledProcessError as e:
        logging.error(f"Error running ADB command: {e}")


def adb(cmd):
    try:
        subprocess.run(["adb", "shell", cmd], check=True)
        logging.debug(f"ADB command sent: {cmd}")
    except subprocess.CalledProcessError as e:
        logging.error(f"Error running ADB command: {e}")


def create_centered_window(height, width, y, x):
    win = curses.newwin(height, width, y, x)
    win.box()
    return win


def draw_screen(stdscr, main_win, status_win):
    stdscr.clear()
    screen_height, screen_width = stdscr.getmaxyx()

    # Resize and reposition main window
    main_height, main_width = screen_height - 6, screen_width - 4
    main_y, main_x = 1, 2
    main_win.resize(main_height, main_width)
    main_win.mvwin(main_y, main_x)
    main_win.clear()
    main_win.box()

    # Add title
    title = "ADB Remote" # subprocess.check_output("adb-activity")
    main_win.addstr(2, (main_width - len(title)) // 2, title, curses.A_BOLD)

    # Add instructions
    instructions = [
        ("↑↓←→", "navigation"),
        ("enter", "select"),
        ("b", "back"),
        ("h", "home"),
        ("m", "menu"),
        ("f", "media skip Forward"),
        ("v", "volume up"),
        ("c", "volume down"),
        ("space", "play/pause"),
        ("w", "enter WiFi password"),
        ("d", "debug"),
        ("q", "quit"),
    ]

    for i, (key, desc) in enumerate(instructions):
        y = 5 + i
        x = (main_width - len(key) - len(desc) - 5) // 2
        if y < main_height - 1 and x > 0:
            main_win.addstr(y, x, key, curses.A_BOLD)
            main_win.addstr(y, x + len(key) + 2, ": ")
            main_win.addstr(y, x + len(key) + 4, desc)

    # Resize and reposition status window
    status_win.resize(3, screen_width - 4)
    status_win.mvwin(screen_height - 4, 2)
    status_win.clear()
    status_win.box()
    status_win.addstr(1, 2, "Ready. Press a key to send a command.")

    # Refresh windows
    stdscr.noutrefresh()
    main_win.noutrefresh()
    status_win.noutrefresh()
    curses.doupdate()


def main(stdscr):
    logging.debug("Starting main function")

    curses.curs_set(0)
    stdscr.clear()
    stdscr.refresh()

    screen_height, screen_width = stdscr.getmaxyx()
    main_win = create_centered_window(screen_height - 6, screen_width - 4, 1, 2)
    status_win = create_centered_window(3, screen_width - 4, screen_height - 4, 2)

    draw_screen(stdscr, main_win, status_win)

    key_mappings = {
        curses.KEY_UP: 19,  # KEYCODE_DPAD_UP
        curses.KEY_DOWN: 20,  # KEYCODE_DPAD_DOWN
        curses.KEY_LEFT: 21,  # KEYCODE_DPAD_LEFT
        curses.KEY_RIGHT: 22,  # KEYCODE_DPAD_RIGHT
        10: 66,  # KEYCODE_ENTER (10 is the ASCII code for Enter)
        ord("b"): 4,  # KEYCODE_BACK
        ord("h"): 3,  # KEYCODE_HOME
        ord("m"): 82,  # KEYCODE_MENU
        ord("f"): 272,  # KEYCODE_MEDIA_SKIP_FORWARD
        ord("v"): 24,  # KEYCODE_VOLUME_UP
        ord("c"): 25,  # KEYCODE_VOLUME_DOWN
        ord(" "): 85,  # KEYCODE_MEDIA_PLAY_PAUSE (Space bar)
        ord("d"): 82,  # Debug: https://reactnative.dev/docs/debugging
    }

    stdscr.nodelay(True)  # Make getch non-blocking

    last_draw_screen = time.time()

    while True:
        try:
            if (time.time() - last_draw_screen) >= 5:
                draw_screen(stdscr, main_win, status_win)
                last_draw_screen = time.time()

            key = stdscr.getch()

            if key == curses.KEY_RESIZE:
                logging.debug("Terminal resized")
                continue

            if key == -1:  # No key pressed
                continue

            logging.debug(f"Key pressed: {key}")

            if key == ord("q"):
                break

            if key in key_mappings:
                adb_keyevent(key_mappings[key])
                status_msg = f"Sent keycode: {key_mappings[key]}"
                if key == ord(" "):
                    status_msg += " (Play/Pause)"
            elif key == ord("w"):
                adb("input text " + WIFI_PASSWORD)
                adb_keyevent(85)
                status_msg = f"typed mobile password"
            else:
                status_msg = "Invalid key. Try again."

            status_win.clear()
            status_win.box()
            status_win.addstr(1, 2, status_msg)
            status_win.refresh()
            logging.debug(f"Status updated: {status_msg}")
        except Exception as e:
            logging.exception("An error occurred in the main loop")
            status_win.clear()
            status_win.box()
            status_win.addstr(1, 2, f"Error: {str(e)}")
            status_win.refresh()

    logging.debug("Exiting main loop")


if __name__ == "__main__":
    logging.debug("Starting application")
    try:
        curses.wrapper(main)
    except Exception as e:
        logging.exception("An error occurred in the main application")
    logging.debug("Application ended")
