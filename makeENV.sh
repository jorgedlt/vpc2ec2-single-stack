#!/usr/bin/env bash

# this take the proto cfg file and creates a runtime ENV file.

cat createCFG.proto | grep export | grep -v '^#' > createCFG.env

#
