import datetime


# Format-String Float and Integer
# ===============================
# https://www.w3schools.com/python/ref_string_format.asp
formatPlaceholders = '''
    :< 	Left aligns the result (within the available space)
    :> 	Right aligns the result (within the available space)
    :^ 	Center aligns the result (within the available space)
    := 	Places the sign to the left most position
    :+ 	Use a plus sign to indicate if the result is positive or negative
    :- 	Use a minus sign for negative values only
    :  	Use a space to insert an extra space before positive numbers (and a minus sign befor negative numbers)
    :, 	Use a comma as a thousand separator
    :_ 	Use a underscore as a thousand separator
    :b 	Binary format
    :c 	Converts the value into the corresponding unicode character
    :d 	Decimal format (Integer)
    :e 	Scientific format, with a lower case e
    :E 	Scientific format, with an upper case E
    :f 	Fix point number format
    :F 	Fix point number format, in uppercase format (show inf and nan as INF and NAN)
    :g 	General format
    :G 	General format (using a upper case E for scientific notations)
    :o 	Octal format
    :x 	Hex format, lower case
    :X 	Hex format, upper case
    :n 	Number format
    :% 	Percentage format
'''
totalFormat = "{t:20.3f}"

anzahl = 10   # integer
preis = 23.56 # float

print("1234567890123456789012345678901234567890123456789012345678901234567890")
print(("Position: {anz:3d}   {preis:15.2f}  ==> " + totalFormat).format(anz=anzahl, t=anzahl*preis, preis=preis))

anzahl = 9     # integer
preis = 100.90 # float
print(("Position: {anz:3d}   {preis:15.2f}  ==> " + totalFormat).format(anz=anzahl, t=anzahl*preis, preis=preis))

anzahl = 9     # integer
preis = 1003458.905 # float
print(("Position: {anz:3d}   {preis:15.2f}  ==> " + totalFormat).format(anz=anzahl, t=anzahl*preis, preis=preis))

print()
print("1234567890123456789012345678901234567890123456789012345678901234567890")
print("We have {:<8} chickens.".format(49))
print("We have {:<8} chickens.".format(21.5))

# Date and Time and Format
# ========================
# https://www.w3schools.com/python/python_datetime.asp
dateFormatPlaceholders = '''
    %a 	Weekday, short version 	Wed 	
    %A 	Weekday, full version 	Wednesday 	
    %w 	Weekday as a number 0-6, 0 is Sunday 	3 	
    %d 	Day of month 01-31 	31 	
    %b 	Month name, short version 	Dec 	
    %B 	Month name, full version 	December 	
    %m 	Month as a number 01-12 	12 	
    %y 	Year, short version, without century 	18 	
    %Y 	Year, full version 	2018 	
    %H 	Hour 00-23 	17 	
    %I 	Hour 00-12 	05 	
    %p 	AM/PM 	PM 	
    %M 	Minute 00-59 	41 	
    %S 	Second 00-59 	08 	
    %f 	Microsecond 000000-999999 	548513 	
    %z 	UTC offset 	+0100 	
    %Z 	Timezone 	CST 	
    %j 	Day number of year 001-366 	365 	
    %U 	Week number of year, Sunday as the first day of week, 00-53 	52 	
    %W 	Week number of year, Monday as the first day of week, 00-53 	52 	
    %c 	Local version of date and time 	Mon Dec 31 17:41:00 2018 	
    %x 	Local version of date 	12/31/18 	
    %X 	Local version of time 	17:41:00 	
    %% 	A % character 	% 	
    %G 	ISO 8601 year 	2018 	
    %u 	ISO 8601 weekday (1-7) 	1 	
    %V 	ISO 8601 weeknumber (01-53) 	01    
'''

def getTimestamp():
    formatStr = '{ts:%m%d%H%M%S    Jahr %Y   %A  %B}'
    return formatStr.format(ts=datetime.datetime.now())

print()
print(getTimestamp())
