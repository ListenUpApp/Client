import 'package:fpdart/fpdart.dart';

import 'errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid<T> = Future<Either<Failure, void>>;
typedef DataMap = Map<String, dynamic>;
