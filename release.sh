#!/bin/bash

# This script generates a new release based on the current branch
# with destination into a release branch:
# development, qa, or production

release_env=$1
curr_tag=$(cat ./release.txt)


