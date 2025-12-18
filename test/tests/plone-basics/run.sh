#!/bin/bash
set -eo pipefail

dir="$(dirname "$(readlink -f "$BASH_SOURCE")")"

image="$1"

PLONE_TEST_SLEEP=5
PLONE_TEST_TRIES=20

cname="plone-container-$RANDOM-$RANDOM"
cid="$(docker run -d --name "$cname" "$image")"
trap "docker rm -vf $cid > /dev/null" EXIT

get() {
	docker run --rm -i \
		--link "$cname":plone \
		--entrypoint /app/bin/python \
		"$image" \
		-c "from urllib.request import urlopen; con = urlopen('$1'); print(con.read())"
}

. "$dir/../../retry.sh" --tries "$PLONE_TEST_TRIES" --sleep "$PLONE_TEST_SLEEP" get "http://plone:8080"

# Plone is up and running
[[ "$(get 'http://plone:8080')" == *"Welcome to Plone!"* ]]