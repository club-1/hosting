#!/bin/bash
DIR="${BASH_SOURCE%/*}"

# Inplace and line loop edit file from first arg
perl -i -p "$DIR/../lib/club1/dns-bump.pl" $1
