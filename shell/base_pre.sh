#!/bin/bash

set -e
set -u

# Variables
PACKAGES="curl unzip"

#
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -qq ${PACKAGES} < /dev/null > /dev/null
