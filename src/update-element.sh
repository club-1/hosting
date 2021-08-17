#!/bin/bash

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

repo=vector-im/element-web
cwd=/home/nicolas/www/riot.club1.fr

tag=$(get_latest_release $repo)
dir=element-$tag
tar=$dir.tar.gz
asc=$tar.asc
url=https://github.com/$repo/releases/download/$tag

cd $cwd
cur=$(readlink current)

wget -nv $url/$tar $url/$asc
if gpg --verify $asc
then
	rm -rf $dir
	tar -xf $tar
	cp config.json $dir/
	ln -fs $dir current
	if [ $cur != $dir ]
	then
		rm -rf $cur
	fi
	echo success
else
	echo fail
fi

rm $tar $asc
