#!/bin/bash

# cd to the target workspace
cd /root/target_ws/

# Combine .coverage files & Combine result to xml
python -m coverage combine `find . -type f -name .coverage`
python -m coverage xml -o coverage_py.xml

# Generate Cpp coverage xml
gcovr --xml-pretty > coverage_cpp.xml

# Setup & Upload Codacy Reporter
curl -Ls -o codacy-coverage-reporter "$(curl -Ls https://api.github.com/repos/codacy/codacy-coverage-reporter/releases/latest | jq -r '.assets | map({name, browser_download_url} | select(.name | contains("codacy-coverage-reporter-linux"))) | .[0].browser_download_url')"
chmod +x codacy-coverage-reporter

# Report Python coverage
./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT -l Python -r coverage_py.xml

# Report C++ coverage
./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT --language Cpp --force-language -r coverage_cpp.xml