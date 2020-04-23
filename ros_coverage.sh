#!/usr/bin/env bash

source <(curl -s https://codecov.io/env)

add "CATKIN_TEST_COVERAGE=1"
add "CODACY_REPORT"
add "CODECOV_REPORT"
add "ADDITIONAL_DEBS='python-coverage curl jq gcovr'"
add "AFTER_SCRIPT='bash <(curl -s https://raw.githubusercontent.com/rarrais/ros_coverage/develop/.ros_coverage/after_script.sh)'"

if [ "$CODACY_PROJECT_TOKEN" != "" ];
then
  add 'CODACY_PROJECT_TOKEN'
fi
