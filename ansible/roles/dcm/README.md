# data-capture-module

This host will recieve uploads by rsync over ssh (user running a generated script).  Users will upload to time-limited user accounts; this accounts are restricted to file transfer only (by rssh) and time-limited (parameterized in script creation).

For the moment, recieve requests from frontend here as well (POST requests of json to http://$HOSTNAME/ur.py).

