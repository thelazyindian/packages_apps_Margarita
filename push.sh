#!/bin/bash
AUTHOR_NAME="$(git log -1 $TRAVIS_COMMIT --pretty="%aN")"
FILENAME=Margarita-debug-$(date +"%Y%m%d-%H:%M").apk
COMMIT=$(git log -1 $TRAVIS_COMMIT --pretty="%h")
MSG="Build [#${TRAVIS_BUILD_NUMBER}](https://travis-ci.org/${TRAVIS_REPO_SLUG}/builds/${TRAVIS_BUILD_ID}) ([${COMMIT}](https://github.com/${TRAVIS_REPO_SLUG}/commit/${TRAVIS_COMMIT})) of ${TRAVIS_REPO_SLUG}@${TRAVIS_BRANCH} by ${AUTHOR_NAME} passed."
mv app/build/outputs/apk/debug/app-debug.apk ${FILENAME}
CHANGELOG="*Changelog:*
`$(git log ${TRAVIS_COMMIT_RANGE} --pretty=format:'%h: %s by %aN%n')`"
curl https://slack.com/api/files.upload -F token=${TOKEN} -F channels=#margarita -F title=${FILENAME} -F filename=${FILENAME} -F file=@${FILENAME}
curl https://api.telegram.org/bot${BOT_TOKEN}/sendDocument -F chat_id=${CHAT_ID} -F document=@${FILENAME}
curl https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d "chat_id=${CHAT_ID}&text=${CHANGELOG}&parse_mode=markdown"
curl https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d "chat_id=${CHAT_ID}&text=${MSG}&parse_mode=markdown"
