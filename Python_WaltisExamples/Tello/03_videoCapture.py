from djitellopy import tello
import cv2 as cv

# Für Video-Streaming: Firewall ausschalten!!!!!!
# Settings --> Update & Security --> Windows Security --> firewall & Network Protection --> Public Netwerk --> Microsoft Defender Firewall auf off schalten!

mySpeed = 30

me = tello.Tello()
me.connect()
print(me.get_battery())
me.streamon()


while True:
    frame = me.get_frame_read().frame
    frame = cv.resize(frame, (480, 360), interpolation= cv.INTER_AREA)
    bat = me.get_battery()
    height = me.get_height()
    attitude = me.get_attitude()
    cv.putText(frame, ("Bat: " + str(bat)), (10, 50), cv.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0))
    cv.putText(frame, ("Alt: " + str(height)), (10, 70), cv.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0))
    cv.putText(frame, ("Att: " + str(attitude)), (10, 90), cv.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0))

    cv.imshow("Output", frame)
    k = cv.waitKey(1) & 0xFF
    if k == 27:
        me.land()
    if k == ord('w'):
        me.send_rc_control(0, mySpeed, 0, 0)
    if k == ord('s'):
        me.send_rc_control(0, -mySpeed, 0, 0)
    if k == ord('a'):
        me.send_rc_control(-mySpeed, 0, 0, 0)
    if k == ord('d'):
        me.send_rc_control(mySpeed, 0, 0, 0)
    if k == ord('q'):
        me.send_rc_control(0, 0, 0, int(-mySpeed))
    if k == ord('e'):
        me.send_rc_control(0, 0, 0, int(mySpeed))

    if k == ord('x'):
        me.send_rc_control(0, 0, 0, 0)

    if k == ord(' '):
        me.takeoff()
