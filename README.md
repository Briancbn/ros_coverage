# ROS Coverage

[![Build Status](https://travis-ci.com/rarrais/ros_coverage.svg?branch=master)](https://travis-ci.com/rarrais/ros_coverage) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/dce8bf91f0314ab0b4c38cfb1998b724)](https://www.codacy.com/manual/rarrais/ros_coverage?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=rarrais/ros_coverage&amp;utm_campaign=Badge_Grade) 

Code coverage for ROS ([Robot Operating System](https://www.ros.org/)), integrated with the [Industrial CI](https://github.com/ros-industrial/industrial_ci) configuration 📈

## Table of Contents

* [Usage](#usage)
* [License](#license)

## <a name="usage"></a> Usage

Currently, only the Travis CI platform is supported and only for public repositories hosted in GitHub.

Code coverage can currently be provided by [Codecov](https://codecov.io/) and/or [Codacy](https://www.codacy.com/).

### For Travis CI

1. Make sure that your ROS package has the appropriate CMAKE_CXX_FLAGS for code coverage specified the CMakeList.txt file.

  * For Python packages:

    ```cmake
    if (CATKIN_ENABLE_TESTING)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")
      ...
    endif()
    ```
  * For C++ packages:

    ```cmake
    if(CATKIN_ENABLE_TESTING)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage -fprofile-arcs -ftest-coverage")
      ...
    endif()
    ```


2. Activate CI for your GitHub repository on Travis CI (follow [Industrial CI instructions](https://github.com/ros-industrial/industrial_ci#for-travis-ci)).
3. Activate code coverage for your repository on Codecov and/or Codacy.
4. For Codacy, it is necessary to set up the code coverage feature. Copy the Repository Token to a Travis CI private Environment Variable (accessible on the repository's settings menu) named ```CODACY_PROJECT_TOKEN```.
5. Edit the Industrial CI [travis.yml](https://github.com/ros-industrial/industrial_ci/blob/legacy/doc/.travis.yml) file with an extra global variable, and select in the matrix which configuration will run which code coverage report provider. Note that a code coverage report provider can only be instantiated once, otherwise reports might be conflictive between different jobs. See the example bellow:

    ```yml
    language: generic
    services:
      - docker

    env:
      global:
        - DOCKER_RUN_OPTS=`bash <(curl -s https://raw.githubusercontent.com/rarrais/ros_coverage/master/ros_coverage.sh)`
      matrix:
        - ROS_DISTRO="melodic"  CODACY="true"  CODECOV="true"
        - ROS_DISTRO="kinetic"
    install:
      - git clone --quiet --depth 1 https://github.com/ros-industrial/industrial_ci.git .industrial_ci -b master
    script:
      - .industrial_ci/travis.sh
    ```

## <a name="license"></a>License

MIT