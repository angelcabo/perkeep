#!/bin/sh

export CAMLI_CONFENV_SECRET_RING=$(camtool env srcroot)/pkg/jsonsign/testdata/test-secring.gpg
export CAMLI_CONFIG_DIR=$(camtool env srcroot)/dev/config-dir-local

# Redundant, but:
export CAMLI_DEFAULT_SERVER=dev
