#!/bin/bash

ws="/root/target_ws"

# Setup & Upload Codacy Reporter
curl -Ls -o codacy-coverage-reporter "$(curl -Ls https://api.github.com/repos/codacy/codacy-coverage-reporter/releases/latest | jq -r '.assets | map({name, browser_download_url} | select(.name | contains("codacy-coverage-reporter-linux"))) | .[0].browser_download_url')"
chmod +x $ws/codacy-coverage-reporter

# Combine .coverage files & Combine result to xml & Report Python coverage to Codacy
(cd $ws && exec python -m coverage combine `find $ws -type f -name .coverage`)
if [ $? -eq 0 ]; then
  (cd $ws && exec python -m coverage xml -o $ws/coverage_py.xml)
  ./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT -l Python -r $ws/coverage_py.xml
fi

# Generate C++ coverage xml & Report C++ coverage to Codacy
if [[ ! -z `find $ws -type f -name *.gcda` ]]; then
  gcovr -r $ws --xml-pretty > $ws/coverage_cpp.xml
  ./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT --language Cpp --force-language -r $ws/coverage_cpp.xml
fi
