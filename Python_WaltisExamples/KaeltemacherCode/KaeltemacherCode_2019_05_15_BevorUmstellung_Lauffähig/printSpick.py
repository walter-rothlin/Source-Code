#!/usr/bin/python3

# ----------------------------------------
#
# Name:        BZU.py
# Description: Testet den print Befehl
# Author:      Walter Rothlin
#
# History:
# 01-March-2018	Walter Rothlin	Initial Version
# 
# ----------------------------------------



name      = "Rothlin"         # String variable
vorname   = "Tobias"          # String variable
zweitName = "Max"             # String variable
aInt      = 9                 # Integer variable
bInt      = 2                 # Integer variable
aFloat    = 3.1415926         # Float variable
bFloat    = 2.71              # Float variable
aBoolean  = True              # Boolean variable
bBoolean  = False             # Boolean variable


# Variablen und Konstanten als einzelne Function Argumente                     
print(name , vorname,zweitName)                                                #Rothlin Tobias Max
print(name , vorname,zweitName, sep="")                                        #RothlinTobiasMax
print(name, " --> ", vorname,zweitName , sep="")                               #Rothlin --> TobiasMax
print(name, " , ", vorname,zweitName , sep="")                                 #Rothlin , TobiasMax
print(name, ",", vorname,zweitName)                                            #Rothlin , Tobias Max
print(name, vorname,zweitName , sep=" == ")                                    #Rothlin == Tobias == Max
print(aInt, bInt, aFloat, bFloat, aBoolean)                                    #9 2 3.1415926 2.71 True
                                                                               
# Berechnungen                                                                 
print(aInt, "*" , bInt,"=",aInt*bInt)                                          #9 * 2 = 18
print(bInt, "*" , bFloat, "=",bInt*bFloat)                                     #2 * 2.71 = 5.42
print(bFloat, "/" , bInt, "=", bFloat/bInt,sep="")                             #2.71/2=1.355
print("Radius:" , bInt,"  Umfang:",2*aFloat)                                   #Radius: 2   Umfang: 6.2831852
                                                                               
# String concationation                                                        
print(name + " " + vorname + " == " + zweitName)                               #Rothlin Tobias == Max
print(name + " " + vorname,zweitName,sep="=")                                  #Rothlin Tobias=Max
                                                                               
# Type-Casts                                                                   
print("Radius=" + str(bFloat) + " Fläche:", bFloat*aFloat)                     #Radius=2.71 Fläche: 8.513715946
                                                                               
# Ohne Zeilenumbruch                                                           
print(name,end="",flush=True)                                                  
print(vorname)                                                                 #RothlinTobias
                                                                               
                                                                               
# format the pythonic way                                                      
strOut = "Art: {0:5d}, Price: {1:8.2f}, {{".format(4523,59.058)                
print(strOut)                                                                  #Art:  4523, Price:    59.06, {
                                                                               
strOut1 = "Art: {art:5d}, Price: {price:8.2f},".format(art=53,price=1259.058)  
print(strOut1)                                                                 #Art:    53, Price:  1259.06, 
                                                                               
strOut2 = "Art: {art:<05d}, Price: {price:8.2f},".format(art=53,price=1259.058)
print(strOut2)                                                                 #Art: 53000, Price:  1259.06, 
                                                                               
strOut3 = "Art: {art:>05d}, Price: {price:8.2f},".format(art=53,price=1259.058)
print(strOut3)                                                                 #Art: 00053, Price:  1259.06, 
                                                                               
strOut4 = "Art: {art:^05d}, Price: {price:8.2f},".format(art=53,price=1259.058)
print(strOut4)                                                                 #Art: 05300, Price:  1259.06, 
                                                                               
strOut5 = "Art: {art:5d}, Price: {price:8.2f},".format(art=-53,price=1259.058) 
print(strOut5)                                                                 #Art:   -53, Price:  1259.06, 
                                                                               
strOut6 = "Art: {art:=5d}, Price: {price:8.2f},".format(art=-53,price=1259.058)
print(strOut6)                                                                 #Art: -  53, Price:  1259.06, 
                                                                               
                                                                               
                                                                               
# format string (C style)                                                      
print("12345678901234567890")                                                  #12345678901234567890
print("%f"% (1234.456))                                                        #1234.456000
print("%10.2f"% (1234.456))                        # rechts bündig             #   1234.46
print("%-10.2f"% (1234.456 * 2), "::",sep=";")     # links bündig              #2468.91   ;::
print("\n")                                                                    
                                                                               
radius = 5.0                                                                   
flaeche = radius*radius*3.1415                                                 
print("%10.2f::%10.3f::"  % (flaeche,radius))                                  #     78.54::     5.000::
print("%-10.2f::%10.3f::" % (flaeche,radius))                                  #78.54     ::     5.000::
print("123456789012345678901234567890")                                        #12345678901234567890
                                                                               
                                                                               
# rjust, ljust, center                                                         
s = "Python"                                                                   
print(s.center(10))      # '  Python  '                                        #  Python
print(s.center(10,"*"))  # '**Python**'                                        #**Python**
                                                                               
s = "Training"                                                                 
print(s.ljust(12))       # 'Training    '                                      #Training
print(s.ljust(12,":") )  # 'Training::::'                                      #Training::::
                                                                               
s = "Programming"                                                              
print(s.rjust(15))       # '    Programming'                                   #    Programming
print(s.rjust(15, "~"))  # '~~~~Programming'                                   #~~~~Programming
