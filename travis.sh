#!/bin/bash

echo "Exporting env variables"

export AFTER_SCRIPT='bash <(curl -s https://raw.githubusercontent.com/rarrais/ros_coverage/master/codacy.sh)'
export BUILDER='catkin_make'
export ADDITIONAL_DEBS='python-coverage curl jq gcovr'
export DOCKER_RUN_OPTS='-e CATKIN_TEST_COVERAGE=1 -e TRAVIS_COMMIT -e CODACY_PROJECT_TOKEN'
