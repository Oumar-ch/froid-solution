// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/client.dart';
import '../services/client_service.dart';
import '../themes/app_colors.dart';
import '../models/contrat_types.dart';
import '../screens/edit_client_dialog.dart';
import '../utils/responsive.dart';

class ClienteleScreen extends StatefulWidget {
  const ClienteleScreen({super.key});

  @override
  State<ClienteleScreen> createState() => _ClienteleScreenState();
}

class _ClienteleScreenState extends State<ClienteleScreen> {
  List<Client> _clients = [];
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late String _contratType;

  @override
  void initState() {
    super.initState();
    _loadClients();
    _nameController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
    _contratType = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadClients() async {
    final clients = await ClientService().getClients();
    if (!mounted) return;
    setState(() {
      _clients = clients;
    });
  }

  Future<void> _editClient(Client client) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => EditClientDialog(client: client),
    );
    if (result == true && mounted) await _loadClients();
  }

  Future<void> _deleteClient(Client client) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.getSurfaceColor(isDark),
        title: Text('Supprimer', style: AppTextStyles.title(isDark)),
        content:
            Text('Supprimer ce client ?', style: AppTextStyles.body(isDark)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Annuler', style: AppTextStyles.body(isDark)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Supprimer',
                style: AppTextStyles.body(isDark)
                    .copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ClientService().deleteClient(client.id);
      if (mounted) await _loadClients();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);
    // Liste des types de contrat issue du modèle
    final List<String> contratTypes = List<String>.from(kContratTypes);
    if (_contratType.isNotEmpty && !contratTypes.contains(_contratType)) {
      contratTypes.insert(0, _contratType);
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.padding(context),
        vertical: Responsive.padding(context) / 2,
      ),
      itemCount: _clients.length,
      itemBuilder: (context, i) {
        final client = _clients[i];
        return GlassmorphicContainer(
          width: double.infinity,
          margin:
              EdgeInsets.only(bottom: Responsive.isMobile(context) ? 12 : 20),
          borderRadius: 18,
          blur: 8,
          border: 1.2,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.13),
              Colors.white.withOpacity(0.09),
            ],
          ),
          borderGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.38),
              Colors.white.withOpacity(0.13),
            ],
          ),
          height: Responsive.isMobile(context)
              ? 140
              : (Responsive.isTablet(context) ? 170 : 190),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 12 : 24,
              vertical: Responsive.isMobile(context) ? 8 : 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(client.name,
                          style: AppTextStyles.label(isDark).copyWith(
                              fontSize: Responsive.font(context, 16),
                              fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: neon,
                              size: Responsive.isMobile(context) ? 20 : 26),
                          onPressed: () => _editClient(client),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete,
                              color: AppColors.error,
                              size: Responsive.isMobile(context) ? 20 : 26),
                          onPressed: () => _deleteClient(client),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: neon.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(client.contact,
                          style: AppTextStyles.body(isDark).copyWith(
                              fontSize: Responsive.font(context, 13))),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 16, color: neon.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(client.address,
                          style: AppTextStyles.body(isDark).copyWith(
                              fontSize: Responsive.font(context, 13))),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.assignment,
                        size: 16, color: neon.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(client.contratType,
                          style: AppTextStyles.body(isDark).copyWith(
                              fontSize: Responsive.font(context, 13),
                              fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
