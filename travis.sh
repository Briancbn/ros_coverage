#!/bin/bash

echo "Exporting env variables"

export AFTER_SCRIPT='wget -O - https://raw.githubusercontent.com/rarrais/ros_coverage/master/codacy.sh | bash'
export BUILDER='catkin_make'
export ADDITIONAL_DEBS='python-coverage jq gcovr'
export DOCKER_RUN_OPTS='-e CATKIN_TEST_COVERAGE=1 -e TRAVIS_COMMIT -e CODACY_PROJECT_TOKEN -e AFTER_SCRIPT -e BUILDER -e ADDITIONAL_DEBS'

printenv 
