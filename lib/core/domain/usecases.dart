import 'types.dart';

abstract interface class UsecaseWithParams<Type, Params> {
  const UsecaseWithParams();
  ResultFuture<Type> call(Params params);
}

abstract interface class UsecaseWithoutParams<Type> {
  const UsecaseWithoutParams();
  ResultFuture<Type> call();
}
