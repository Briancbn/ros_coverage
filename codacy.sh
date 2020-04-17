#!/bin/bash

ws="/root/target_ws"

# Chang directory to ws, as to not trigger permission errors
cd $ws

# Setup & Upload Codacy Reporter
curl -Ls -o codacy-coverage-reporter "$(curl -Ls https://api.github.com/repos/codacy/codacy-coverage-reporter/releases/latest | jq -r '.assets | map({name, browser_download_url} | select(.name | contains("codacy-coverage-reporter-linux"))) | .[0].browser_download_url')"
chmod +x codacy-coverage-reporter

# Combine .coverage files & Combine result to xml & Report Python coverage to Codacy
python -m coverage combine `find . -type f -name .coverage`
if [ $? -eq 0 ]; then
  python -m coverage xml -o coverage_py.xml
  ./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT -l Python -r coverage_py.xml
fi

# # Generate C++ coverage xml & Report C++ coverage to Codacy
if [[ ! -z `find $ws -type f -name *.gcda` ]]; then
  gcovr -r $ws --xml-pretty > coverage_cpp.xml
  ./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT --language Cpp --force-language -r coverage_cpp.xml
fi
