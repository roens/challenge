#!/bin/bash

# This script generates a new release based on the current branch
# with destination into a release branch:
# development, qa, or production

# Ask user to confirm
read -p "You've asked to publish a new release tag. Continue? " choice
case "$choice" in
    y|Y|yes ) echo "Awesome, proceeding.";;
    *	    ) echo "Ok then, nothing done."; exit 99;;
esac

release_env=$1
# Verify provided env is valid
case "$release_env" in
    development|qa|production	) echo "Environment: ${release_env}";;
    *				) echo "Environment must be in: development, qa, or production."; exit 99;;
esac

# Set aside current IFS & set to '.' for conversion of version string into array
OIFS=$IFS
IFS='.'

# Gather the current desired release and latest git tag
curr_rel=( $(cat ./release.txt) )
curr_tag=( $(git describe --abbrev=0 --tags) )
IFS=$OIFS

# Increment the patch only if latest commit is new

old_patch=${curr_tag[3]}
new_patch=$(( curr_tag[3] += 1 ))
desired_tag="${curr_rel[0]}.${curr_rel[1]}.${new_patch}"
echo "Old version tag: ${curr_tag[0]}.${curr_tag[1]}.${curr_tag[2]}"
echo "New version tag: ${desired_tag}"
echo "Releasing ${desired_tag} to  ${release_env}"

# Get the current branch name
curr_git_branch=$(git rev-parse --abbrev-ref HEAD)

# Switch to the desired release branch
git checkout ${release_env}

# Merge that current branch into the release branch
git merge ${curr_git_branch}

# Set the new version tag
git tag -a ${desired_tag}
