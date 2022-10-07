import 'package:mason_logger/mason_logger.dart';

enum APIService {
  dio,
  http,
}

class Status {
  static late Progress progress;
  static late Logger logger;

  static init(log) => logger = log;

  static start(String message) => progress = logger.progress(message);

  static end(String message) => progress.complete(message);
}
