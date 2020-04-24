#!/usr/bin/env python

"""
ROS Code Coverage Class (Python).
This module demonstrates code coverage and code quality for ROS Python applications.
"""

class RosCCClass(object):
    """Example of a Python Class for code coverage purposes."""

    def __init__(self, identifier, name='default'):
        """
        ROS Code Coverage __init__ method.

        Args:
            identifier (string): identification parameter
            name (string): name parameter
        """

        self.identifier = identifier
        self.name = name

    def set_name(self, name):
        """
        Method for changing the name parameter

        Args:
            name (string): name parameter
        """
        self.name = name

    def get_name(self):
        """
        Method for getting the name parameter

        Returns:
            name (string)
        """
        return self.name
