#!/bin/bash
DIR="${BASH_SOURCE%/*}"
. "$DIR/../lib/club1/functions.sh"

# From config
repo=mstilkerich/rcmcarddav
cwd=/var/lib/roundcube/plugins

tag=$(getLatestGithubRelease $repo)
dir=carddav
tar=$dir-$tag.tar.gz
url=https://github.com/$repo/releases/download/$tag

confirm "update $repo to $tag"

cd $cwd

wget -nv $url/$tar
rm -rf $dir
tar -xf $tar
ln -s /etc/roundcube/plugins/carddav/config.inc.php $dir/
echo success
rm $tar
