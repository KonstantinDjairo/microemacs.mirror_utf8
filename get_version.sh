#!/bin/sh
srcdir=$1
[ -n "$srcdir" ] || exit 1

# Use DATE_OVERRIDE or fallback to today
: "${DATE_OVERRIDE:=$(date -I)}"
echo "#define DATE \"$DATE_OVERRIDE\"" >rev.h

# Use REV_OVERRIDE or fallback to git/fossil
if [ -n "$REV_OVERRIDE" ]; then
  echo "#define REV \"$REV_OVERRIDE\"" >>rev.h
elif [ -f "$srcdir/.fslckout" ]; then
  fossil info | sed -n 's/checkout: *\(..........\).*/#define REV "fossil-\1"/p' >>rev.h
else
  git rev-parse HEAD | sed -n 's/^\(.......\).*/#define REV "git-\1"/p' >>rev.h
fi
