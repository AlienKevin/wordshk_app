# Start collecting screenshots
```bash
python screenshot.py
```

# Clear ADB
Sometimes, the ADB server might not be in the correct state.
Try restarting the ADB server using `adb kill-server` followed by `adb start-server`.

# Set up the iOS simulator
The simulator is binding (by default) the keyboard layout of the host macOS system with the one in the sim,
and apparently iOS can't change the keyboard layout without changing the language of the environment.
So, tried unchecking the option I/O > Keyboard > Use the same Keyboard Language as macOS and lo and behold,
the inconvenient behaviour stopped.