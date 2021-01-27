import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoDataConnectionChecker implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  NetworkInfoDataConnectionChecker(this.dataConnectionChecker);
  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
