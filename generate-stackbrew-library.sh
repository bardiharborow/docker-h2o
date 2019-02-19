#!/bin/bash
set -eu

self="$(basename "$BASH_SOURCE")"
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

# get the most recent commit which modified any of "$@"
fileCommit() {
	git log -1 --format='format:%H' HEAD -- "$@"
}

# get the most recent commit which modified "$1/Dockerfile" or any file COPY'd from "$1/Dockerfile"
dirCommit() {
	local dir="$1"; shift
	(
		cd "$dir"
		fileCommit \
			Dockerfile \
			$(git show HEAD:./Dockerfile | awk '
				toupper($1) == "COPY" {
					for (i = 2; i < NF; i++) {
						print $i
					}
				}
			')
	)
}

cat <<-EOH
# this file is generated via https://github.com/bardiharborow/docker-h2o/blob/$(fileCommit "$self")/$self

Maintainers: Bardi Harborow <bardi@bardiharborow.com> (@bardiharborow)
GitRepo: https://github.com/bardiharborow/docker-h2o.git
EOH

commit="$(dirCommit .)"

fullVersion="$(git show "$commit":"Dockerfile" | awk '$1 == "ENV" && $2 == "H2O_VERSION" { print $3; exit }')"

versionAliases="$( echo "$fullVersion" | awk -F '.' '{ print $1", "$1"."$2; exit }')"

echo
cat <<-EOE
	Tags: $fullVersion, $versionAliases, latest
	Architectures: amd64
	GitCommit: $commit
EOE
