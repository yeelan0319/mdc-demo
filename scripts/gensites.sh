#!/bin/bash
#
# Copyright 2015-present Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
GITHUB_REMOTE=`git remote -v | grep "fetch" | sed -e 's/origin.//' | sed -e 's/.(fetch)//'`

JEKYLL_VERSION=`jekyll --version`
if [[ $? != 0 ]]; then
	echo "Cannot find jekyll.  To install try:"
	echo "[sudo] gem install github-pages"
	exit 1
fi

# If docs folder exists, pull the lastest gp-pages
# Else create docs folder and create a new jekyll site structure inside

if [ -d ./docs ]
then
{
 cd docs
 git checkout gh-pages
 git pull
 cd - > /dev/null
}
else	
{
	mkdir docs
	git clone $GITHUB_REMOTE docs
	cd docs 
	git checkout gh-pages
	cd - > /dev/null
}
fi

# Sweap over components folder, grab each .md file and copy them into ./docs/_posts as folder name
for component in $(ls ./components); do
	cd components/$component
	cp $component.md ../../docs/_posts/2016-02-17-$component.md
	cd - > /dev/null
done ;

# # run ```jekyll serve``` inside that folder and prompt user to view the local version at localhost:4000
cd docs && jekyll serve

# trap "echo CTRL-C was pressed" 2