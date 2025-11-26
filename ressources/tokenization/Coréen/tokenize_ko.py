import warnings

warnings.filterwarnings("ignore", category=UserWarning) 
import os
os.environ["CUDA_VISIBLE_DEVICES"] = "-1"

from pykospacing import Spacing
import errno
import fileinput

spacing = Spacing()

try:
    for line in fileinput.input():
        print(spacing(line))
except IOError as e:
    if e.errno != errno.EPIPE:
        raise
