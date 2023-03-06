#!/bin/bash

TMPDIR=/tmp/special/slideshow

pkill slideshow_start
pkill imv-x11
rm -rdf "${TMPDIR}"