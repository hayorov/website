#!/usr/bin/env bash

set -euf -o pipefail

SCRIPTPATH="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1
    pwd -P
)"

BUILD_HASH=$(git rev-parse --short HEAD)
BUILD_DATE=$(git show -s --format=%ci)

echo "Add revision ${BUILD_HASH} | ${BUILD_DATE}"
sed -i '' "s/[[GIT_COMMIT]]/${BUILD_HASH}/g" "${SCRIPTPATH}/content/resume-footer.html"
sed -i '' "s/[[GIT_DATE]]/${BUILD_DATE}/g" "${SCRIPTPATH}/content/resume-footer.html"

echo "Render static PDF from .md"
mdpdf "${SCRIPTPATH}/content/resume.md" "${SCRIPTPATH}/static/cv/alex-khaerov-resume-latest.pdf" --format=A4 \
    --header content/resume-header.html --footer content/resume-footer.html
