#!/bin/bash
DIR="${BASH_SOURCE%/*}"
. "$DIR/../lib/club1/functions.sh"

# From config
repo=$element_repo
cwd=$element_dir

tag=$(getLatestGithubRelease $repo)
dir=element-$tag
tar=$dir.tar.gz
asc=$tar.asc
url=https://github.com/$repo/releases/download/$tag

cd $cwd
cur=$(readlink current)

wget -nv $url/$tar $url/$asc
if gpg --verify $asc
then
	confirm
	rm -rf $dir
	tar -xf $tar
	ln -s ../config.json $dir/config.json
	rm -f current
	ln -s $dir current
	if [ $cur != $dir ]
	then
		diff --color -u $cur/config.sample.json $dir/config.sample.json
		rm -rf $cur
	fi
	echo success
else
	echo fail
fi

rm $tar $asc
