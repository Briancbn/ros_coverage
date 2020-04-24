cmake_minimum_required(VERSION 2.8.3)
project(ros_cc_cpp)

find_package(catkin REQUIRED COMPONENTS
  roscpp
)

###################################
## catkin specific configuration ##
###################################

catkin_package(
  INCLUDE_DIRS include
  LIBRARIES ros_cc_cpp_library
  CATKIN_DEPENDS roscpp
)

###########
## Build ##
###########

include_directories(include)

add_library(ros_cc_cpp_library
  src/ros_cc_cpp_class.cpp
)

target_link_libraries(ros_cc_cpp_library
  ${catkin_LIBRARIES}
)

#############
## Install ##
#############

install(TARGETS ros_cc_cpp_library
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
)

install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
  FILES_MATCHING PATTERN "*.h"
  PATTERN ".svn" EXCLUDE
)

#############
## Testing ##
#############

if(CATKIN_ENABLE_TESTING)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage -fprofile-arcs -ftest-coverage")
  catkin_add_gtest(ros_cc_cpp_library_tests test/test_ros_cc_cpp_class.cpp)
  target_link_libraries(ros_cc_cpp_library_tests ros_cc_cpp_library ${catkin_LIBRARIES})
endif()
