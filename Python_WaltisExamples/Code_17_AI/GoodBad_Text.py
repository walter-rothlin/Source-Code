import requests

# https://machinelearningforkids.co.uk/

# This function will pass your text to the machine learning model
# and return the top result with the highest confidence
def classify(text):
    key = "09bee3c0-6f08-11ed-b72a-45afd285c04cfde3ee18-d83b-464a-99e8-7374db61b469"
    url = "https://machinelearningforkids.co.uk/api/scratch/"+ key + "/classify"

    response = requests.get(url, params={ "data" : text })

    if response.ok:
        responseData = response.json()
        topMatch = responseData[0]
        return topMatch
    else:
        response.raise_for_status()


# CHANGE THIS to something you want your machine learning model to classify
demo = classify("Es ist guter Food")

label = demo["class_name"]
confidence = demo["confidence"]


# CHANGE THIS to do something different with the result
print ("result: '%s' with %d%% confidence" % (label, confidence))