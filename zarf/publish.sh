#!/bin/bash

## read the version from nfpm
v=$(cat nfpm.yaml | grep version | cut -d":" -f 2 | tr -d '"' | xargs)
VERSION="v$v"
# get the token from local fs
TOKEN=$(cat "$HOME/.goreleaser/github-cloud-token")

# create release
payload='{"tag_name":"'"$VERSION"'","target_commitish":"main","name":"'"$VERSION"'","body": "Release '"$VERSION"'","draft":false,"prerelease":false,"generate_release_notes":false}'
response=$(curl -s \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $TOKEN" \
  "https://api.github.com/repos/andresbott/elementary-breeze/releases" \
  -d "$payload")

# the the release id from the response
ID=$(jq -r '.id' <<< "$response")
#echo "relase ID: $ID"

echo "Uploading asset"
## upload asset to the release
FILENAME=$(basename 'elementary-breeze_'"$v"'_all.deb')
curl -s \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: $(file -b --mime-type "$FILENAME")" \
  --data-binary @"$FILENAME" \
  "https://uploads.github.com/repos/andresbott/elementary-breeze/releases/$ID/assets?name=$FILENAME"