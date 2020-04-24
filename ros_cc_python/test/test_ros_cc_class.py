#!/usr/bin/env python

"""Tests for the ROS Code Coverage Class (Python)."""

from unittest import TestCase
from ros_cc_python.ros_cc_class import RosCCClass


class TestRosCCClass(TestCase):
    """Test class for the ROS Code Coverage Class (Python)."""

    def test_instance_creation(self):
        """Tests the creation of a class instance"""
        test_identifier = "tIdentifier"
        test_instance = RosCCClass(test_identifier)

        self.assertEqual(test_identifier, test_instance.identifier)

    def test_set_name(self):
        """Tests the name setting method"""
        test_instance = RosCCClass("tIdentifier")

        test_name = "tName"
        test_instance.set_name(test_name)

        self.assertEqual(test_name, test_instance.name)

    def test_get_name(self):
        """Tests the name getting method"""
        test_name = "tName"

        test_instance = RosCCClass("tIdentifier", test_name)

        self.assertEqual(test_name, test_instance.get_name())


if __name__ == '__main__':
    import rosunit

    rosunit.unitrun('ros_cc_python', 'test_ros_cc_class', TestRosCCClass)
