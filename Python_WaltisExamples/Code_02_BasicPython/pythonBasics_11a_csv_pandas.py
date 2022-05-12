#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_11a_csv_pandas.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_11a_csv_pandas.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import numpy as np
import pandas as pd
from io import StringIO

# https://pandas.pydata.org/docs/user_guide/10min.html

# ---------------------------
print("\nSelction 1:")
s = pd.Series([1, 3, 5, np.nan, 6, 8])
print(s)


# ---------------------------
print("\nSelction 2:")
df2 = pd.DataFrame(
    {
        "A": 1.0,
        "B": pd.Timestamp("20130102"),
        "C": pd.Series(1, index=list(range(4)), dtype="float32"),
        "D": np.array([3] * 4, dtype="int32"),
        "E": pd.Categorical(["test", "train", "test", "train"]),
        "F": "foo",
    }
)
print(df2, "\n")

print(df2.dtypes, "\n")
print(df2.head(2), "\n")
print(df2.tail(1), "\n")

# ---------------------------
print("\nSelction 3:")
dates = pd.date_range("20130101", periods=6, freq="D")
print(dates)

df = pd.DataFrame(np.random.randn(6, 4), index=dates, columns=list("ABCD"))
print(df, "\n")
print(df.T, "\n")
print(df.T.describe(), "\n")
print(df.sort_index(axis=1, ascending=False), "\n")
print(df.sort_values(by="C", ascending=False), "\n")
print(df[2:3], "\n")
print(df["A"], "\n")
print(df[1:3]["A"], "\n")
print(df.loc["20130102":"20130104", ["B", "A"]], "\n")
df.iat[0, 1] = 0
df.iat[2, 1] = 0
print(df, "\n")
print(df[df["B"] > 0], "\n")
print(df.to_json(), "\n")

# ---------------------------





# https://pandas.pydata.org/docs/user_guide/io.html#index-columns-and-trailing-delimiters


data = "a,b,c,d\n1.0,2.0,3.0,4.0\n1.1,2.1,3.1,4.1\n1.2,2.2,3.2"
print(data, "\n")
print(pd.read_csv(StringIO(data), dtype=object), "\n")
print(pd.read_csv(StringIO(data), dtype=object)["b"][0:2], "\n")

data = """
      a,   b,   c,   d
#  Real Data
    1.0, 2.0, 3.0, 4.0
    1.1, 2.1, 3.1, 4.1
    1.2, 2.2, 3.2
"""
print(data, "\n")
print(pd.read_csv(StringIO(data), dtype=object), "\n")
print(pd.read_csv(StringIO(data), dtype=object, skipinitialspace=True), "\n")
print(pd.read_csv(StringIO(data), names=["foo", "bar", "baz", "daz"], header=None), "\n")
print(pd.read_csv(StringIO(data), names=["foo", "bar", "baz", "daz"], header=0, skipinitialspace=True, comment="#", sep=","), "\n")

data = """
       a|    b|    c|    d
    10.0| 20.0| 30.0| 40.0
    10.1| 20.1| 30.1| 40.1
    10.2| 20.2| 30.2| 123456.0
"""
print(data, "\n")
df = pd.read_csv(StringIO(data), names=["foo", "bar", "baz", "daz"], header=0, skipinitialspace=True, comment="#", sep="|")
print(df, "\n")
print(len(df))
print(df, "\n")

exit(1)