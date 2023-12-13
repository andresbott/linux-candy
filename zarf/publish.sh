#!/bin/bash

## read the version from nfpm
v=$(cat nfpm.yaml | grep version | cut -d":" -f 2 | tr -d '"' | xargs)
VERSION="v$v"
# get the token from local fs

if [[ -z "${GH_TOKEN}" ]]; then
  echo "Env \$GH_TOKEN with a Github Token is not set."
  echo "create a Github token with repo scopes here: https://github.com/settings/tokens"
  exit 1
fi


# create release
payload='{"tag_name":"'"$VERSION"'","target_commitish":"main","name":"'"$VERSION"'","body": "Release '"$VERSION"'","draft":false,"prerelease":false,"generate_release_notes":false}'
response=$(curl -s \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $GH_TOKEN" \
  "https://api.github.com/repos/andresbott/linux-candy/releases" \
  -d "$payload")

# the the release id from the response
ID=$(jq -r '.id' <<< "$response")
#echo "relase ID: $ID"

echo "Uploading asset"
## upload asset to the release
FILENAME=$(basename 'linux-candy_'"$v"'_all.deb')
curl -s \
  -H "Authorization: token $GH_TOKEN" \
  -H "Content-Type: $(file -b --mime-type "$FILENAME")" \
  --data-binary @"$FILENAME" \
  "https://uploads.github.com/repos/andresbott/linux-candy/releases/$ID/assets?name=$FILENAME"