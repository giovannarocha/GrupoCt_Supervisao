import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'store_take_picture.g.dart';

class StoreTakePicture = _StoreTakePictureBase with _$StoreTakePicture;

abstract class _StoreTakePictureBase with Store {
  @observable
  File file;
  @action
  changeImage(newValue) {
    file = newValue;
  }

  @observable
  bool isEnabled = true;

  @action
  changeifIsEnabled() {
    if (isEnabled) {
      isEnabled = false;
    } else {
      isEnabled = true;
    }
  }

  @observable
  var controller = TextEditingController();
  @action
  clearValue() {
    controller.clear();
  }
}
