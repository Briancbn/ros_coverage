#include <gtest/gtest.h>
#include <string>

#include "ros_cc_cpp_library/ros_cc_cpp_class.h"

using ros_cc_cpp_library::RosCCCppClass;


TEST(RosCCCppClassTestSuite, checkConstructor)
{
    std::string test_identifier("test_identifier");
    RosCCCppClass test_instance(test_identifier);

    ASSERT_EQ(test_identifier, test_instance.identifier);
}

TEST(RosCCCppClassTestSuite, checkGetSetName)
{
    std::string test_identifier("test_identifier");
    RosCCCppClass test_instance(test_identifier);

    std::string test_name("test_name");

    test_instance.setName(test_name);

    ASSERT_EQ(test_name, test_instance.getName());
}

int main(int argc, char **argv)
{
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
