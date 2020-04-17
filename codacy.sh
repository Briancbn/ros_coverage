#!/bin/bash

## ENVIRONMENT ##
env_definition()
{
  # WS="/root/target_ws"
  WS="/home/rarrais/catkin_ws"

  PY_FAIL_UNDER_COV_THRESHOLD="true"
  PY_COV_THRESHOLD=80
  
  CPP_FAIL_UNDER_COV_THRESHOLD="true"
  CPP_COV_THRESHOLD=80
}

## CODACY ##

install_codacy_reporter()
{
  curl -Ls -o codacy-coverage-reporter "$(curl -Ls https://api.github.com/repos/codacy/codacy-coverage-reporter/releases/latest | jq -r '.assets | map({name, browser_download_url} | select(.name | contains("codacy-coverage-reporter-linux"))) | .[0].browser_download_url')"
  chmod +x codacy-coverage-reporter
}

python_codacy_report()
{
  ./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT -l Python -r coverage_py.xml
}

cpp_codacy_report()
{
  ./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT --language Cpp --force-language -r coverage_cpp.xml
}

## CODE COVERAGE ANALYSIS ##

python_code_coverage()
{
  # Attempts to Combine .coverage files
  python -m coverage combine `find . -type f -name .coverage`
  if [ $? -eq 0 ]; then
    # Combine results to xml
    python -m coverage xml -o coverage_py.xml
    
    python_codacy_report

    # Shows results and tests if below a given coverage threshold
    python -m coverage report -m --skip-empty --fail-under=$PY_COV_THRESHOLD
    if [[ $? -eq 2 && "$CPP_FAIL_UNDER_COV_THRESHOLD" == "true" ]]; then
      # Fails if below a given coverage threshold
      echo "Failed! Under Python Threshold criteria."
      exit 2
    fi
  fi
}

cpp_code_coverage()
{
  # Checks if there are Cpp tests with code coverage results
  if [[ ! -z `find $WS -type f -name *.gcda` ]]; then
    # Generate C++ coverage xml
    gcovr -r $WS --xml-pretty > coverage_cpp.xml

    cpp_codacy_report

    # Shows results and tests if below a given coverage threshold
    gcovr -r $WS --fail-under-line=$CPP_COV_THRESHOLD
    if [[ $? -eq 2 && "$PY_FAIL_UNDER_COV_THRESHOLD" == "true" ]]; then
      # Fails if below a given coverage threshold
      echo "Failed! Under C++ Threshold criteria."
      exit 2
    fi
  fi
}

env_definition

# Chang directory to WS, as to not trigger permission errors
cd $WS

install_codacy_reporter
python_code_coverage
cpp_code_coverage
