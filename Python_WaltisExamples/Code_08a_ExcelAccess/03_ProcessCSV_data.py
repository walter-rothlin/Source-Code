import pandas as pd

df = pd.read_csv("G:\_WaltisDaten\SourceCode\GitHosted\DatenFiles\CSV_Excel\Adressliste_1.txt", sep=";")
print(df)
print('1) ---------------------------------------------------')

print(df['Email'], df['TEL_P'])
print('2) ---------------------------------------------------')

print(df.query("Geschlecht == 'Frau'")['TEL_P'])
print('3) ---------------------------------------------------')

print(df.filter(like='055'))
print('4) ---------------------------------------------------')
