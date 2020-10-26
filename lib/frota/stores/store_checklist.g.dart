// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_checklist.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StoreCheckList on _StoreCheckListBase, Store {
  final _$fuelLevelAtom = Atom(name: '_StoreCheckListBase.fuelLevel');

  @override
  String get fuelLevel {
    _$fuelLevelAtom.context.enforceReadPolicy(_$fuelLevelAtom);
    _$fuelLevelAtom.reportObserved();
    return super.fuelLevel;
  }

  @override
  set fuelLevel(String value) {
    _$fuelLevelAtom.context.conditionallyRunInAction(() {
      super.fuelLevel = value;
      _$fuelLevelAtom.reportChanged();
    }, _$fuelLevelAtom, name: '${_$fuelLevelAtom.name}_set');
  }

  final _$fuelValueAtom = Atom(name: '_StoreCheckListBase.fuelValue');

  @override
  double get fuelValue {
    _$fuelValueAtom.context.enforceReadPolicy(_$fuelValueAtom);
    _$fuelValueAtom.reportObserved();
    return super.fuelValue;
  }

  @override
  set fuelValue(double value) {
    _$fuelValueAtom.context.conditionallyRunInAction(() {
      super.fuelValue = value;
      _$fuelValueAtom.reportChanged();
    }, _$fuelValueAtom, name: '${_$fuelValueAtom.name}_set');
  }

  final _$radioValueAtom = Atom(name: '_StoreCheckListBase.radioValue');

  @override
  int get radioValue {
    _$radioValueAtom.context.enforceReadPolicy(_$radioValueAtom);
    _$radioValueAtom.reportObserved();
    return super.radioValue;
  }

  @override
  set radioValue(int value) {
    _$radioValueAtom.context.conditionallyRunInAction(() {
      super.radioValue = value;
      _$radioValueAtom.reportChanged();
    }, _$radioValueAtom, name: '${_$radioValueAtom.name}_set');
  }

  final _$_StoreCheckListBaseActionController =
      ActionController(name: '_StoreCheckListBase');

  @override
  dynamic fuelChange(dynamic value) {
    final _$actionInfo = _$_StoreCheckListBaseActionController.startAction();
    try {
      return super.fuelChange(value);
    } finally {
      _$_StoreCheckListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic radioValueChange(int value) {
    final _$actionInfo = _$_StoreCheckListBaseActionController.startAction();
    try {
      return super.radioValueChange(value);
    } finally {
      _$_StoreCheckListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'fuelLevel: ${fuelLevel.toString()},fuelValue: ${fuelValue.toString()},radioValue: ${radioValue.toString()}';
    return '{$string}';
  }
}
