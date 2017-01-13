#!/bin/sh

# https://appventure.me/2016/04/04/prevent-accidental-test-code-commits/

if git rev-parse --verify HEAD >/dev/null 2>&1
then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

# The special marker tag to mark things which we still need to change
marker="<TEST>"

# Redirect output to stderr.
exec 1>&2

if test $(git diff --cached -z $against | grep $marker | wc -c) != 0 
then
    cat <<\EOF
    Error: Still has invalid debug markers in code:
EOF
    echo `git diff --cached -z $against -G $marker`
    exit 1
fi
