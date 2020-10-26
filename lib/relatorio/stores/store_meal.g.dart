// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_meal.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StoreMeal on _StoreMealBase, Store {
  final _$startAtom = Atom(name: '_StoreMealBase.start');

  @override
  String get start {
    _$startAtom.context.enforceReadPolicy(_$startAtom);
    _$startAtom.reportObserved();
    return super.start;
  }

  @override
  set start(String value) {
    _$startAtom.context.conditionallyRunInAction(() {
      super.start = value;
      _$startAtom.reportChanged();
    }, _$startAtom, name: '${_$startAtom.name}_set');
  }

  final _$endAtom = Atom(name: '_StoreMealBase.end');

  @override
  String get end {
    _$endAtom.context.enforceReadPolicy(_$endAtom);
    _$endAtom.reportObserved();
    return super.end;
  }

  @override
  set end(String value) {
    _$endAtom.context.conditionallyRunInAction(() {
      super.end = value;
      _$endAtom.reportChanged();
    }, _$endAtom, name: '${_$endAtom.name}_set');
  }

  final _$_StoreMealBaseActionController =
      ActionController(name: '_StoreMealBase');

  @override
  dynamic changeStart(dynamic newValue) {
    final _$actionInfo = _$_StoreMealBaseActionController.startAction();
    try {
      return super.changeStart(newValue);
    } finally {
      _$_StoreMealBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'start: ${start.toString()},end: ${end.toString()}';
    return '{$string}';
  }
}
