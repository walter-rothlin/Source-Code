# Erkennt handschriftliche Buchstaben: A, B, C, D

# Trainieren: https://machinelearningforkids.co.uk/ und Model über REST aufrufen


from mlforkids import MLforKidsImageProject

# treat this key like a password and keep it secret!
key = "30d6c740-6eed-11ed-bebc-0fef71f91f14c48567f9-6e17-47cd-a760-3bbd71340d38"

# this will train your model and might take a little while
myproject = MLforKidsImageProject(key)
myproject.train_model()

# CHANGE THIS to the image file you want to recognize
demo = myproject.prediction("my-test-image.jpg")

label = demo["class_name"]
confidence = demo["confidence"]

# CHANGE THIS to do something different with the result
print("result: '%s' with %d%% confidence" % (label, confidence))
