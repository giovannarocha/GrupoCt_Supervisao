// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_supervisor.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StoreSupervisor on _StoreSupervisorBase, Store {
  final _$supervisorAtom = Atom(name: '_StoreSupervisorBase.supervisor');

  @override
  Supervisor get supervisor {
    _$supervisorAtom.context.enforceReadPolicy(_$supervisorAtom);
    _$supervisorAtom.reportObserved();
    return super.supervisor;
  }

  @override
  set supervisor(Supervisor value) {
    _$supervisorAtom.context.conditionallyRunInAction(() {
      super.supervisor = value;
      _$supervisorAtom.reportChanged();
    }, _$supervisorAtom, name: '${_$supervisorAtom.name}_set');
  }

  final _$setDataAsyncAction = AsyncAction('setData');

  @override
  Future setData() {
    return _$setDataAsyncAction.run(() => super.setData());
  }

  @override
  String toString() {
    final string = 'supervisor: ${supervisor.toString()}';
    return '{$string}';
  }
}
