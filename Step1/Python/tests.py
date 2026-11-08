import unittest
import os
import numpy as np
from Step1 import *

class TEST_so3ToVec(unittest.TestCase):

    def test_zeros(self):
        so3 = np.zeros((3,3))
        actual = so3ToVec(so3)
        expected = np.array([0,0,0])
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

    def test_identity(self):
        so3 = np.eye(3)
        actual = so3ToVec(so3)
        expected = np.array([0,0,0])
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')
    
    def test_positive(self):
        so3 = np.array([[0, -3, 2], [3, 0, -1], [-2, 1, 0]])
        actual = so3ToVec(so3)
        expected = np.array([1,2,3])
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

    def test_negative(self):
        so3 = -1*np.array([[0, -3, 2], [3, 0, -1], [-2, 1, 0]])
        actual = so3ToVec(so3)
        expected = -1*np.array([1,2,3])
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

class TEST_VecToso3(unittest.TestCase):

    def test_zeros(self):
        vec = np.zeros(3)
        actual = VecToso3(vec)
        expected = np.zeros((3,3))
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

    def test_nonzero(self):
        vec = np.array([1,2,3])
        actual = VecToso3(vec)
        expected = np.array([[0, -3, 2], [3, 0, -1], [-2, 1, 0]])
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

class TEST_MatrixLog3(unittest.TestCase):

    def test_identity(self):
        R = np.eye(3)
        actual = MatrixLog3(R)
        expected = np.zeros((3,3))
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

    def test_180_case1(self):
        R = np.array([[-1, 0, 0], [0, -1, 0], [0, 0, 1]])
        actual = MatrixLog3(R)
        expected = np.array([[0, -np.pi, 0], [np.pi, 0, 0], [0, 0, 0]])
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

    def test_180_case2(self):
        R = np.array([[-1, 0, 0], [0, 1, 0], [0, 0, -1]])
        actual = MatrixLog3(R)
        expected = np.array([[0, 0, np.pi], [0, 0, 0], [-np.pi, 0, 0]])
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

    def test_180_case3(self):
        R = np.array([[1, 0, 0], [0, -1, 0], [0, 0, -1]])
        actual = MatrixLog3(R)
        expected = np.array([[0, 0, 0], [0, 0, -np.pi], [0, np.pi, 0]])
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

    def test_typical_case(self):
        theta = np.pi/4
        R = np.array([[np.cos(theta), -np.sin(theta), 0], [np.sin(theta), np.cos(theta), 0], [0, 0, 1]])
        actual = MatrixLog3(R)
        expected = np.array([[0, -np.pi/4, 0], [np.pi/4, 0, 0], [0, 0, 0]])
        self.assertTrue(np.allclose(actual, expected), f'Expected {expected}, got {actual}')

class TEST_AngleAxis3(unittest.TestCase):

    def test_zero(self):
        w_theta = np.array([0, 0, 0])
        actual_w, actual_theta = AngleAxis3(w_theta)
        expected_w, expected_theta = np.array([0, 0, 0]), 0

        self.assertTrue(np.allclose(actual_w, expected_w), f'Expected {expected_w}, got {actual_w}')
        self.assertTrue(np.allclose(actual_theta, expected_theta), f'Expected {expected_theta}, got {actual_theta}')

    def test_identity(self):
        w_theta = np.array([0, 0, 1])
        actual_w, actual_theta = AngleAxis3(w_theta)
        expected_w, expected_theta = np.array([0, 0, 1]), 1

        self.assertTrue(np.allclose(actual_w, expected_w), f'Expected {expected_w}, got {actual_w}')
        self.assertTrue(np.allclose(actual_theta, expected_theta), f'Expected {expected_theta}, got {actual_theta}')

    def test_negative(self):
        w_theta = np.array([0, 0, -1])
        actual_w, actual_theta = AngleAxis3(w_theta)
        expected_w, expected_theta = np.array([0, 0, -1]), 1

        self.assertTrue(np.allclose(actual_w, expected_w), f'Expected {expected_w}, got {actual_w}')
        self.assertTrue(np.allclose(actual_theta, expected_theta), f'Expected {expected_theta}, got {actual_theta}')

    def test_typical(self):
        w_theta = np.array([2, 7, 26])
        actual_w, actual_theta = AngleAxis3(w_theta)
        expected_w, expected_theta = np.array([2/27, 7/27, 26/27]), 27

        self.assertTrue(np.allclose(actual_w, expected_w), f'Expected {expected_w}, got {actual_w}')
        self.assertTrue(np.allclose(actual_theta, expected_theta), f'Expected {expected_theta}, got {actual_theta}')

if __name__ == '__main__':
    current_folder = os.path.basename(os.getcwd())
    if current_folder != 'Python':
        print(f'Please run the test from Lab3/Step1/Python directory. You are currently in {current_folder}')
        print(f'Hint: cd ~/ece569-spring2026/Lab3/Step1/Python')
    else:

        # run all of the unit tests using
        # python3 tests.py
        unittest.main(verbosity=2)

        # Note: if you just want to run a specific test, do something like this from the Lab2/Step1/Python directory:
        # python3 -m unittest tests.TEST_VecToso3 -v
        # python3 -m unittest tests.TEST_so3ToVec -v
        # python3 -m unittest tests.TEST_AngleAxis3 -v
        # python3 -m unittest tests.TEST_MatrixLog3 -v
    
