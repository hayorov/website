#!/usr/bin/env bash

set -euf -o pipefail

BUILD_HASH=$(git rev-parse --short HEAD)
BUILD_DATE=$(git show -s --format=%ci)

echo "Add revision ${BUILD_HASH} | ${BUILD_DATE}"
sed -i '' -e "s/[[GIT_COMMIT]]/${BUILD_HASH}/g" content/resume-footer.html
sed -i '' -e "s/[[GIT_DATE]]/${BUILD_DATE}/g" content/resume-footer.html

echo "Render static PDF from .md"
mdpdf content/resume.md static/cv/alex-khaerov-resume-latest.pdf --format=A4 \
    --header content/resume-header.html --footer content/resume-footer.html
