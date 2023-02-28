import pandas as pd

# Create a sample dataframe
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6], 'C': [7, 8, 9]})

# Write the dataframe to an xlsx file
df.to_excel('sample.xlsx', index=False)



import pandas as pd

# Read the data from an xlsx file
df = pd.read_excel('sample.xlsx')

# Print the dataframe
print(df)
