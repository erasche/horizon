#!/bin/sh
git fetch origin --quiet
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @{0})
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @{0} "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
	# echo "Up-to-date"
elif [ $LOCAL = $BASE ]; then
	# If we need to pull, instead, pull + restart httpd.
	echo "Deploying!"
	git pull
	systemctl restart httpd
elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
else
    echo "Diverged"
fi
