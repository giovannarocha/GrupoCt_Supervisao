// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_take_picture.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StoreTakePicture on _StoreTakePictureBase, Store {
  final _$fileAtom = Atom(name: '_StoreTakePictureBase.file');

  @override
  File get file {
    _$fileAtom.context.enforceReadPolicy(_$fileAtom);
    _$fileAtom.reportObserved();
    return super.file;
  }

  @override
  set file(File value) {
    _$fileAtom.context.conditionallyRunInAction(() {
      super.file = value;
      _$fileAtom.reportChanged();
    }, _$fileAtom, name: '${_$fileAtom.name}_set');
  }

  final _$isEnabledAtom = Atom(name: '_StoreTakePictureBase.isEnabled');

  @override
  bool get isEnabled {
    _$isEnabledAtom.context.enforceReadPolicy(_$isEnabledAtom);
    _$isEnabledAtom.reportObserved();
    return super.isEnabled;
  }

  @override
  set isEnabled(bool value) {
    _$isEnabledAtom.context.conditionallyRunInAction(() {
      super.isEnabled = value;
      _$isEnabledAtom.reportChanged();
    }, _$isEnabledAtom, name: '${_$isEnabledAtom.name}_set');
  }

  final _$controllerAtom = Atom(name: '_StoreTakePictureBase.controller');

  @override
  TextEditingController get controller {
    _$controllerAtom.context.enforceReadPolicy(_$controllerAtom);
    _$controllerAtom.reportObserved();
    return super.controller;
  }

  @override
  set controller(TextEditingController value) {
    _$controllerAtom.context.conditionallyRunInAction(() {
      super.controller = value;
      _$controllerAtom.reportChanged();
    }, _$controllerAtom, name: '${_$controllerAtom.name}_set');
  }

  final _$_StoreTakePictureBaseActionController =
      ActionController(name: '_StoreTakePictureBase');

  @override
  dynamic changeImage(dynamic newValue) {
    final _$actionInfo = _$_StoreTakePictureBaseActionController.startAction();
    try {
      return super.changeImage(newValue);
    } finally {
      _$_StoreTakePictureBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeifIsEnabled() {
    final _$actionInfo = _$_StoreTakePictureBaseActionController.startAction();
    try {
      return super.changeifIsEnabled();
    } finally {
      _$_StoreTakePictureBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearValue() {
    final _$actionInfo = _$_StoreTakePictureBaseActionController.startAction();
    try {
      return super.clearValue();
    } finally {
      _$_StoreTakePictureBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'file: ${file.toString()},isEnabled: ${isEnabled.toString()},controller: ${controller.toString()}';
    return '{$string}';
  }
}
