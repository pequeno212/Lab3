### Python Users
No tutorial is provided. You must use numpy and matplotlib. Be sure not to change the following function signatures, as they are used in the test benches:
* so3ToVec
* VecToso3
* AxisAng3
* MatrixLog3

Starter Code for Step 1 can be found at:
* [Step1.py](Step1.py)

Test Benches are located in a single file:
* [tests.py](tests.py)

To run the test benches, run the python file from the `Lab2/Step1/Python` directory:
```bash
python3 tests.py
```
If you just want to run a specific test, do something like this from the `Lab3/Step1/Python` directory:
```
python3 -m unittest tests.TEST_VecToso3 -v
python3 -m unittest tests.TEST_so3ToVec -v
python3 -m unittest tests.TEST_AngleAxis3 -v
python3 -m unittest tests.TEST_MatrixLog3 -v
```
Of course, if you are on windows you might need to replace `python3` with `python` or `py`.

## Instructions

See the [Overleaf template](https://www.overleaf.com/read/mwyhydwdqwpd#716360) for the actual Step 1 instructions.
