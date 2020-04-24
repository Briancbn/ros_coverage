#ifndef ROS_CC_CPP_LIBRARY_ROS_CI_CPP_CLASS_H
#define ROS_CC_CPP_LIBRARY_ROS_CI_CPP_CLASS_H

#include <string>

namespace ros_cc_cpp_library
{

    class RosCCCppClass
    {
        public:
            RosCCCppClass(std::string i);
            void setName(std::string n);
            std::string getName(void);

            std::string identifier;
        private:
            std::string name;
    };

}  // namespace ros_cc_cpp_library

#endif  // ROS_CC_CPP_LIBRARY_ROS_CC_CPP_CLASS_H
