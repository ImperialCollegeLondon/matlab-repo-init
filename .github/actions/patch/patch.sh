#!/bin/sh

git remote add matlab-repo-init https://github.com/djmaxus/matlab-repo-init.git --fetch --no-tags

release_sha=$(git ls-remote --tags matlab-repo-init | tail -1 | cut -f1)
release_ref=$(git ls-remote --tags matlab-repo-init | tail -1 | cut -f2)

# compile and apply patch
git diff --binary "$(git hash-object -t tree /dev/null)" "$release_sha" > matlab-repo-init.patch
git apply --theirs --3way matlab-repo-init.patch

git add .

git config user.name 'github-actions[bot]'
git config user.email 'github-actions[bot]@users.noreply.github.com'

git commit -m "WIP: matlab-repo-init:$release_ref"

git --no-pager log --decorate=short --pretty=oneline -n1

git checkout -b matlab-repo-init
git push -u origin matlab-repo-init
