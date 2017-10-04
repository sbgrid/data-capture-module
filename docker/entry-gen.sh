#!/bin/sh

/etc/init.d/redis start
rq worker normal

