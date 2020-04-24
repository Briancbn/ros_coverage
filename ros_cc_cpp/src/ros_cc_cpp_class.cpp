#include "ros_cc_cpp_library/ros_cc_cpp_class.h"

#include <string>

namespace ros_cc_cpp_library
{
    RosCCCppClass::RosCCCppClass(std::string i)
    {
        identifier = i;
    }

    void RosCCCppClass::setName(std::string n)
    {
        name = n;
    }

    std::string RosCCCppClass::getName(void)
    {
        return name;
    }

}  // namespace ros_cc_cpp_library
