#!/bin/bash

set -euo pipefail

timestamp=$(date +%s)
branch=branch-${timestamp}

git checkout -b ${branch}
date > ${branch}
git add ${branch}
git commit -m "whatever"
git push origin ${branch}
hub pull-request -m "this is a PR ${timestamp}"
git checkout master
