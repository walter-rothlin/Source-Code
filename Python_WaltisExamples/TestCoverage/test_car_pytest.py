from Car import Car


def test_car_brake():
    car = Car(50)
    car.brake()
    assert car.speed == 45
    car.brake()
    assert car.speed == 40
    print("All tests have passed!")

test_car_brake()
