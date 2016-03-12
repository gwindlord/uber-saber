#!/bin/bash

if [[ "$#" != "2"  ]]; then
  echo "usage: $0 AndroidPreviousRevision AndroidCurrentRevision" >&2
  exit 1
fi

AndroidPreviousRevision="$1"
AndroidCurrentRevision="$2"

# errors on
set -e

repo forall -c "
repo info . | grep Project:
if git rev-parse $AndroidPreviousRevision >/dev/null 2>&1
then
  git log --oneline --no-merges ${AndroidPreviousRevision}..${AndroidCurrentRevision}
else
  git log --oneline --no-merges $AndroidCurrentRevision
fi
"
