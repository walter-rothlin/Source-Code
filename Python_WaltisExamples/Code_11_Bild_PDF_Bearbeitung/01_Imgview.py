import cv2

frame = cv2.imread("./TestOutputFiles/AllFiles_Doppelseiten/BMS_Mathe_001.jpg")
cv2.imshow("Output", frame)
cv2.waitKey(0)
