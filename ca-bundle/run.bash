#!/usr/bin/env bash

set -x

# Get curl's script to convert Mozilla's ca-bundle to the pem format.
wget https://raw.githubusercontent.com/curl/curl/master/lib/mk-ca-bundle.pl

# Download and create a CA bundle.
perl mk-ca-bundle.pl
