import '../models/client.dart';
import '../config/app_config.dart';
import 'database_service.dart';

class ClientService {
  final String apiBaseUrl = AppConfig.apiBaseUrl;
  static final ClientService _instance = ClientService._internal();
  factory ClientService() => _instance;
  ClientService._internal();

  Future<List<Client>> getClients() async {
    return await DataService.getClients();
  }

  Future<void> addClient(Client client) async {
    await DataService.addClient(client);
  }

  Future<void> deleteClient(String id) async {
    await DataService.deleteClient(id);
  }

  Future<void> updateClient(Client client) async {
    await DataService.updateClient(client);
  }
}
