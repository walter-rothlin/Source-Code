#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: Test_Kaeltemaschine.py
#
# Description: 
#
# Destination: ~/Documents/BZU_Code/ExamplesPython/KaeltemacherCode/Version_2019_06_24
# Autor: Walter Rothlin
#
# History:
# 28-Jun-2019	Initial Version
#
# ------------------------------------------------------------------

import math
import time
import datetime
import re
import piplates.DAQCplate as DAQC

from Class_KaelteMacherMaschine import *
from waltisLibrary              import *


hsrKaelteMaschine = KaelteMacherMaschine(simulate = False)
# hsrKaelteMaschine.setHeartbeatInicator(True)

hsrKaelteMaschine.setMixingValve(0)


