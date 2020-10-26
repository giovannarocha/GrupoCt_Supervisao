// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_selecionar_viatura.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StoreSelecionarViatura on _StoreSelecionarViaturaBase, Store {
  final _$viaturasAtom = Atom(name: '_StoreSelecionarViaturaBase.viaturas');

  @override
  List<Frota> get viaturas {
    _$viaturasAtom.context.enforceReadPolicy(_$viaturasAtom);
    _$viaturasAtom.reportObserved();
    return super.viaturas;
  }

  @override
  set viaturas(List<Frota> value) {
    _$viaturasAtom.context.conditionallyRunInAction(() {
      super.viaturas = value;
      _$viaturasAtom.reportChanged();
    }, _$viaturasAtom, name: '${_$viaturasAtom.name}_set');
  }

  final _$errorAtom = Atom(name: '_StoreSelecionarViaturaBase.error');

  @override
  Exception get error {
    _$errorAtom.context.enforceReadPolicy(_$errorAtom);
    _$errorAtom.reportObserved();
    return super.error;
  }

  @override
  set error(Exception value) {
    _$errorAtom.context.conditionallyRunInAction(() {
      super.error = value;
      _$errorAtom.reportChanged();
    }, _$errorAtom, name: '${_$errorAtom.name}_set');
  }

  final _$fetchAsyncAction = AsyncAction('fetch');

  @override
  Future fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  @override
  String toString() {
    final string =
        'viaturas: ${viaturas.toString()},error: ${error.toString()}';
    return '{$string}';
  }
}
