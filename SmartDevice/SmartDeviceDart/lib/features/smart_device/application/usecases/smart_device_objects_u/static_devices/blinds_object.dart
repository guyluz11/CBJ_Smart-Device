import 'package:SmartDeviceDart/features/smart_device/application/usecases/button_object_u/button_object_local.dart';
import 'package:SmartDeviceDart/features/smart_device/application/usecases/devices_pin_configuration_u/pin_information.dart';
import 'package:SmartDeviceDart/features/smart_device/application/usecases/smart_device_objects_u/abstracts_devices/smart_device_static_abstract.dart';
import 'package:SmartDeviceDart/features/smart_device/application/usecases/wish_classes_u/blinds_wish_u.dart';
import 'package:SmartDeviceDart/features/smart_device/domain/entities/enums.dart';
import 'package:SmartDeviceDart/features/smart_device/infrastructure/datasources/core_d/manage_physical_components/device_pin_manager.dart';


class BlindsObject extends SmartDeviceStaticAbstract {


  PinInformation buttonPinUp, blindsUpPin, buttonPinDown, blindsDownPin;


  BlindsObject(macAddress, deviceName, onOffPinNumber,
      onOffButtonPinNumber,
      int blindsUpPin, int upButtonPinNumber, int blindsDownPin, int downButtonPinNumber)
      : super(macAddress, deviceName, onOffPinNumber,
      onOffButtonPinNumber: onOffButtonPinNumber) {
    buttonPinUp = DevicePinListManager().getGpioPin(
        this, upButtonPinNumber);
    buttonPinDown =
        DevicePinListManager().getGpioPin(
            this, downButtonPinNumber);

    this.blindsUpPin =
        DevicePinListManager().getGpioPin(this, blindsUpPin);
    this.blindsDownPin =
        DevicePinListManager().getGpioPin(this, blindsDownPin);
    listenToTwoButtonsPress();
  }


  @override
  Future<String> executeWish(String wishString) async {
    var wish = convertWishStringToWishesObject(wishString);
    return await wishInBlindsClass(wish);
  }

  //  All the wishes that are legit to execute from the blinds class
  Future<String> wishInBlindsClass(WishEnum wish) async {
    if(wish == null) return 'Your wish does not exist in blinds class';
    if (wish == WishEnum.blindsUp) return await BlindsWishU.BlindsUp(this);
    if (wish == WishEnum.blindsDown) return await BlindsWishU.blindsDown(this);
    if (wish == WishEnum.blindsStop) return await BlindsWishU.blindsStop(this);

    return wishInStaticClass(wish);
  }


  void listenToTwoButtonsPress() {
    if (buttonPinUp != null && buttonPinDown != null &&
        blindsUpPin != null && blindsDownPin != null) {
      ButtonObjectLocal()
          .listenToTwoButtonPressedButtOnlyOneCanBePressedAtATime(
          this, buttonPinUp, blindsUpPin, buttonPinDown,
          blindsDownPin);
    }
    else {
      print('Cannot listen to blinds, one of the variables is null');
    }
  }
}