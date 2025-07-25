import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/client.dart';
import '../services/client_service.dart';
import '../themes/app_colors.dart';
import '../models/contrat_types.dart';
import '../utils/responsive.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  String? _contratType;

  Future<void> _addClient() async {
    final name = _nameController.text.trim();
    final contact = _contactController.text.trim();
    final address = _addressController.text.trim();
    final contratType = _contratType;

    // Type de contrat NON OBLIGATOIRE
    if (name.isEmpty || contact.isEmpty || address.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nom, contact et adresse sont obligatoires.')),
      );
      return;
    }

    const uuid = Uuid();
    final client = Client(
      id: uuid.v4(),
      name: name,
      contact: contact,
      address: address,
      contratType:
          contratType ?? '', // Ajoute une valeur vide si rien n'est choisi
    );

    try {
      await ClientService().addClient(client);
      _nameController.clear();
      _contactController.clear();
      _addressController.clear();
      setState(() {
        _contratType = null;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client ajouté avec succès !')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);
    return Padding(
      padding: EdgeInsets.all(Responsive.padding(context)),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: AppInputDecorations.neonField('Nom', isDark),
            style: AppTextStyles.body(isDark)
                .copyWith(fontSize: Responsive.font(context, 14)),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 12 : 20),
          TextField(
            controller: _contactController,
            decoration: AppInputDecorations.neonField('Contact', isDark),
            style: AppTextStyles.body(isDark)
                .copyWith(fontSize: Responsive.font(context, 14)),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 12 : 20),
          TextField(
            controller: _addressController,
            decoration: AppInputDecorations.neonField('Adresse', isDark),
            style: AppTextStyles.body(isDark)
                .copyWith(fontSize: Responsive.font(context, 14)),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 12 : 20),
          DropdownButtonFormField<String>(
            value: _contratType,
            decoration: AppInputDecorations.dropdown('Type de contrat', isDark)
                .copyWith(
              prefixIcon: Icon(Icons.assignment,
                  color: neon, size: Responsive.isMobile(context) ? 20 : 28),
            ),
            dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
            style: TextStyle(
              color: neon,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Orbitron',
            ),
            icon: Icon(Icons.arrow_drop_down, color: neon),
            items: kContratTypes
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type,
                        style: TextStyle(
                          color: neon,
                          fontSize: 14,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _contratType = value),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addClient,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter le client'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: neon,
                foregroundColor: isDark ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 12,
                shadowColor: neon.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
