import numpy as np
import pandas as pd

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



exit(1)

# https://pandas.pydata.org/docs/user_guide/io.html#index-columns-and-trailing-delimiters
import pandas as pd
from io import StringIO

data = "col1,col2,col3\na,b,1\na,b,2\nc,d,3"
pd.read_csv(StringIO(data))
print(pd)

pd.read_csv(StringIO(data), usecols=lambda x: x.upper() in ["COL1", "COL3"])
print(pd)
