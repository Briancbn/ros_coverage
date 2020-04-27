#!/bin/bash

function code_coverage_analysis {
    echo "Running Code Coverage Analysis!"

    local target_ws=$1

    # Python code coverage
    if python -m coverage combine "$(find "$target_ws" -type f -name .coverage)"; then
        python -m coverage xml -o "$target_ws"/coverage_py.xml
    fi

    # C++ code coverage
    if [[ ! -z $(find "$target_ws" -type f -name '*.gcda') ]]; then
        gcovr -r "$target_ws" --xml-pretty > "$target_ws"/coverage_cpp.xml
    fi
}

function code_coverage_report {

  local target_ws=$1

  if [[ "$CODACY" == "true" ]]; then
    curl -Ls -o codacy-coverage-reporter "$(curl -Ls https://api.github.com/repos/codacy/codacy-coverage-reporter/releases/latest | jq -r '.assets | map({name, browser_download_url} | select(.name | contains("codacy-coverage-reporter-linux"))) | .[0].browser_download_url')"
    chmod +x codacy-coverage-reporter

    if [[ -f $target_ws/coverage_py.xml ]]; then
      ./codacy-coverage-reporter report --commit-uuid "$TRAVIS_COMMIT" -l Python -r coverage_py.xml
    fi
    
    if [[ -f $target_ws/coverage_cpp.xml ]]; then
      ./codacy-coverage-reporter report --commit-uuid "$TRAVIS_COMMIT" --language Cpp --force-language -r coverage_cpp.xml
    fi
  fi

  if [[ "$CODECOV" == "true" ]]; then
    curl -s https://codecov.io/bash > .codecov
    chmod +x .codecov

    if [[ -f $target_ws/coverage_py.xml ]]; then
      ./.codecov -f coverage_py.xml -cF python
    fi
    
    if [[ -f $target_ws/coverage_cpp.xml ]]; then
      ./.codecov -f coverage_cpp.xml -cF cpp
    fi
  fi
}

code_coverage_threshold_check()
{
  local target_ws=$1

  # Python code coverage threshold check
  if [[ -f $target_ws/coverage_py.xml ]]; then
    python -m coverage report -m --fail-under="$PY_COV_THRESHOLD"
    if [[ $? -eq 2 && "$PY_FAIL_UNDER_COV_THRESHOLD" == "true" ]]; then
      echo "Failed! Under Python Threshold criteria."
      exit 2
    fi
  fi

  # C++ code coverage threshold check
  if [[ -f $target_ws/coverage_cpp.xml ]]; then
    gcovr -r "$target_ws" --fail-under-line="$CPP_COV_THRESHOLD"
    if [[ $? -eq 2 && "$CPP_FAIL_UNDER_COV_THRESHOLD" == "true" ]]; then
      echo "Failed! Under C++ Threshold criteria."
      exit 2
    fi
  fi
}

target_ws="/root/target_ws"

PY_FAIL_UNDER_COV_THRESHOLD="false"
PY_COV_THRESHOLD=80

CPP_FAIL_UNDER_COV_THRESHOLD="false"
CPP_COV_THRESHOLD=80

# Chang directory to target_ws, as to not trigger permission errors
cd $target_ws || exit

code_coverage_analysis target_ws
code_coverage_report target_ws
code_coverage_threshold_check target_ws
