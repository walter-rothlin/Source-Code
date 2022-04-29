



-- Variante 1
updateSQL = """   
                  UPDATE adressen SET 
                         strasse='""" + strasseStr + """', 
                         hausnummer='""" + hausnummer + """' 
                  WHERE adress_id = """ + str(aRec[0])
mycursor.execute(updateSQL)


-- Variante 2
updateSQL = f"""  UPDATE adressen 
                      SET orte_fk=(SELECT ort_id 
                                   FROM orte 
                                   WHERE name = '{ortStr:s}' AND 
                                         plz = {plzStr:s}) 
                      WHERE ort='{ortStr:s}' AND 
                            plz={plzStr:s}"""
mycursor.execute(updateSQL)


-- Variante 3
sql = "INSERT INTO customers (name, address) VALUES (%s, %s)"
val = ("John", "Highway 21")
mycursor.execute(sql, val)
