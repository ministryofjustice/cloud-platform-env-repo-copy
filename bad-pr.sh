#!/bin/bash

set -euo pipefail

timestamp=$(date +%s)
branch=branch-${timestamp}

git checkout -b ${branch}
date > namespaces/live-1.cloud-platform.service.justice.gov.uk/becca-test-app-dev/${branch}
date > namespaces/live-1.cloud-platform.service.justice.gov.uk/c100-application-metabase/${branch}
date > namespaces/live-1.cloud-platform.service.justice.gov.uk/check-financial-eligibility-production/resources/${branch}
git add namespaces
git commit -m "PR changing 3 namespaces"
git push origin ${branch}
hub pull-request -m "this is a PR ${timestamp}"
git checkout master
