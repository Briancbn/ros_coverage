#!/bin/bash

env_definition()
{
  WS="/root/target_ws"

  PY_FAIL_UNDER_COV_THRESHOLD="true"
  PY_COV_THRESHOLD=80
  
  CPP_FAIL_UNDER_COV_THRESHOLD="true"
  CPP_COV_THRESHOLD=80

  CODACY_REPORT="true"
}

code_coverage_report()
{
  if [[ "$CODACY_REPORT" == "true" ]]; then
    cd $WS
    curl -Ls -o codacy-coverage-reporter "$(curl -Ls https://api.github.com/repos/codacy/codacy-coverage-reporter/releases/latest | jq -r '.assets | map({name, browser_download_url} | select(.name | contains("codacy-coverage-reporter-linux"))) | .[0].browser_download_url')"
    chmod +x codacy-coverage-reporter

    if [[ -f $WS/coverage_py.xml ]]; then
      ./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT -l Python -r coverage_py.xml
    fi
    
    if [[ -f $WS/coverage_cpp.xml ]]; then
      ./codacy-coverage-reporter report --commit-uuid $TRAVIS_COMMIT --language Cpp --force-language -r coverage_cpp.xml
    fi
  fi
}

code_coverage_analysis()
{
  # Python code coverage
  python -m coverage combine `find . -type f -name .coverage`
  if [ $? -eq 0 ]; then
    python -m coverage xml -o coverage_py.xml
  fi

  # C++ code coverage
  if [[ ! -z `find $WS -type f -name *.gcda` ]]; then
    gcovr -r $WS --xml-pretty > coverage_cpp.xml
  fi
}

code_coverage_threshold_check()
{
  # Python code coverage threshold check
  if [[ -f $WS/coverage_py.xml ]]; then
    python -m coverage report -m --fail-under=$PY_COV_THRESHOLD
    if [[ $? -eq 2 && "$PY_FAIL_UNDER_COV_THRESHOLD" == "true" ]]; then
      echo "Failed! Under Python Threshold criteria."
      exit 2
    fi
  fi

  # C++ code coverage threshold check
  if [[ -f $WS/coverage_cpp.xml ]]; then
    gcovr -r $WS --fail-under-line=$CPP_COV_THRESHOLD
    if [[ $? -eq 2 && "$CPP_FAIL_UNDER_COV_THRESHOLD" == "true" ]]; then
      echo "Failed! Under C++ Threshold criteria."
      exit 2
    fi
  fi
}

env_definition

# Chang directory to WS, as to not trigger permission errors
cd $WS

code_coverage_analysis
code_coverage_report
code_coverage_threshold_check
