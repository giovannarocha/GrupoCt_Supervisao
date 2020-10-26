// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_client_report.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StoreClientReport on _StoreClientReportBase, Store {
  final _$listControllerAtom =
      Atom(name: '_StoreClientReportBase.listController');

  @override
  int get listController {
    _$listControllerAtom.context.enforceReadPolicy(_$listControllerAtom);
    _$listControllerAtom.reportObserved();
    return super.listController;
  }

  @override
  set listController(int value) {
    _$listControllerAtom.context.conditionallyRunInAction(() {
      super.listController = value;
      _$listControllerAtom.reportChanged();
    }, _$listControllerAtom, name: '${_$listControllerAtom.name}_set');
  }

  final _$isEnabledAtom = Atom(name: '_StoreClientReportBase.isEnabled');

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

  final _$postsAtom = Atom(name: '_StoreClientReportBase.posts');

  @override
  List<Post> get posts {
    _$postsAtom.context.enforceReadPolicy(_$postsAtom);
    _$postsAtom.reportObserved();
    return super.posts;
  }

  @override
  set posts(List<Post> value) {
    _$postsAtom.context.conditionallyRunInAction(() {
      super.posts = value;
      _$postsAtom.reportChanged();
    }, _$postsAtom, name: '${_$postsAtom.name}_set');
  }

  final _$myPostsAtom = Atom(name: '_StoreClientReportBase.myPosts');

  @override
  List<Post> get myPosts {
    _$myPostsAtom.context.enforceReadPolicy(_$myPostsAtom);
    _$myPostsAtom.reportObserved();
    return super.myPosts;
  }

  @override
  set myPosts(List<Post> value) {
    _$myPostsAtom.context.conditionallyRunInAction(() {
      super.myPosts = value;
      _$myPostsAtom.reportChanged();
    }, _$myPostsAtom, name: '${_$myPostsAtom.name}_set');
  }

  final _$getAllPostsAsyncAction = AsyncAction('getAllPosts');

  @override
  Future getAllPosts() {
    return _$getAllPostsAsyncAction.run(() => super.getAllPosts());
  }

  final _$_StoreClientReportBaseActionController =
      ActionController(name: '_StoreClientReportBase');

  @override
  dynamic controller(dynamic newValue, dynamic area, dynamic shift) {
    final _$actionInfo = _$_StoreClientReportBaseActionController.startAction();
    try {
      return super.controller(newValue, area, shift);
    } finally {
      _$_StoreClientReportBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsEnabled() {
    final _$actionInfo = _$_StoreClientReportBaseActionController.startAction();
    try {
      return super.setIsEnabled();
    } finally {
      _$_StoreClientReportBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'listController: ${listController.toString()},isEnabled: ${isEnabled.toString()},posts: ${posts.toString()},myPosts: ${myPosts.toString()}';
    return '{$string}';
  }
}
