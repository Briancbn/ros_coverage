#!/usr/bin/env bash

source <(curl -s https://codecov.io/env)

add "CATKIN_TEST_COVERAGE=1"
add "CODACY_REPORT"
add "CODECOV_REPORT"

if [ "$CODACY_PROJECT_TOKEN" != "" ];
then
  add "CODACY_PROJECT_TOKEN"
fi
