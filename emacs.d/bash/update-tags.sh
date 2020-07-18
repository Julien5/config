#!/usr/bin/env bash

PID=$1
op $PID --update-tags "${@:2:$#}"
