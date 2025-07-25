// ignore_for_file: unnecessary_import, deprecated_member_use, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/programme_task.dart';
import 'programme_form.dart';
import '../services/programme_service.dart';
import '../widgets/programme_card.dart';
import 'package:pdf/widgets.dart' as pw;
import '../themes/app_colors.dart';
import '../models/client.dart';
import '../models/technicien.dart';
import '../services/database_service.dart';
import 'dart:io';
import '../utils/responsive.dart';

class ProgrammeScreen extends StatefulWidget {
  const ProgrammeScreen({super.key});

  @override
  State<ProgrammeScreen> createState() => _ProgrammeScreenState();
}

class _ProgrammeScreenState extends State<ProgrammeScreen> {
  List<ProgrammeTask> _tasks = [];
  List<Client> _clients = [];
  List<Technicien> _techniciens = [];
  bool _loading = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _loading = true);
    final tasks = await ProgrammeService.getAllTasks();
    debugPrint(
      'Tâches chargées depuis la base: ${tasks.map((e) => e.toMap()).toList()}',
    );
    final clients = await DataService.getClients();
    debugPrint('Clients chargés: ${clients.map((e) => e.toMap()).toList()}');
    final techniciens = await DataService.getTechniciens();
    debugPrint(
      'Techniciens chargés: ${techniciens.map((e) => e.toMap()).toList()}',
    );
    setState(() {
      _tasks = tasks;
      _clients = clients;
      _techniciens = techniciens;
      _loading = false;
    });
    debugPrint('État final _tasks: ${_tasks.length} éléments');
  }

  String? _getClientName(String? clientId) {
    if (clientId == null) return null;
    final c = _clients.firstWhere(
      (cl) => cl.name == clientId || cl.id == clientId,
      orElse: () => Client(
        id: '',
        name: clientId,
        contact: '',
        address: '',
        contratType: '',
      ),
    );
    return c.name;
  }

  String? _getTechnicienName(String? techId) {
    if (techId == null) return null;
    final t = _techniciens.firstWhere(
      (te) => te.id == techId,
      orElse: () => Technicien(
        id: techId,
        nom: techId,
        numero: '',
        adresse: '',
        habilitation: 'novice',
      ),
    );
    return t.nom;
  }

  void _openProgrammeFormForTask(ProgrammeTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ProgrammeForm(
          initial: task,
          onSubmit: (updatedTask) async {
            try {
              await ProgrammeService.updateTask(updatedTask);
              if (!mounted) return;
              await _loadAllData();
            } catch (e, stack) {
              debugPrint('Erreur modification programme: $e\n$stack');
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erreur lors de la modification du programme'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _openProgrammeFormForDate(DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ProgrammeForm(
          initial: ProgrammeTask(
            id: UniqueKey().toString(),
            titre: '',
            date: date,
          ),
          onSubmit: (task) async {
            try {
              await ProgrammeService.addTask(task);
              debugPrint('Programme enregistré: ' + task.toMap().toString());
              if (!mounted) return;
              await _loadAllData();
            } catch (e, stack) {
              debugPrint('Erreur enregistrement programme: $e\n$stack');
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erreur lors de la sauvegarde du programme'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);
    return Scaffold(
      backgroundColor: Colors.transparent, // Ajouté pour transparence totale
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(Responsive.padding(context)),
                      child: GlassmorphicContainer(
                        height:
                            400, // Valeur à ajuster selon votre design/responsive
                        borderRadius: 24,
                        blur: 22, // plus élevé
                        alignment: Alignment.center,
                        border: 1.5,
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.32),
                            Colors.white.withOpacity(0.18),
                          ],
                        ),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.45),
                            Colors.white.withOpacity(0.23),
                          ],
                        ),
                        width: double.infinity,
                        child: Material(
                          color: Colors.transparent,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: TableCalendar(
                              firstDay: DateTime.utc(2020, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (day) =>
                                  isSameDay(_selectedDay, day),
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                                _openProgrammeFormForDate(selectedDay);
                              },
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  color: neon.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: neon,
                                  shape: BoxShape.circle,
                                ),
                                defaultTextStyle: AppTextStyles.body(isDark)
                                    .copyWith(
                                      color: AppColors.getTextColor(isDark),
                                    ),
                                weekendTextStyle: AppTextStyles.body(isDark)
                                    .copyWith(
                                      color: AppColors.getTextSecondaryColor(
                                        isDark,
                                      ),
                                    ),
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: neon,
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: neon,
                                ),
                                titleTextStyle: AppTextStyles.label(isDark),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_tasks.isEmpty)
                      Center(
                        child: Text(
                          'Aucune programmation',
                          style: AppTextStyles.bodySecondary(
                            isDark,
                          ).copyWith(fontSize: 16),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: _tasks.length,
                        itemBuilder: (context, i) {
                          final t = _tasks[i];
                          debugPrint('Affichage card programme: ${t.toMap()}');
                          final clientName = _getClientName(t.client) ?? '-';
                          final technicienName =
                              _getTechnicienName(t.technicienId) ?? '-';
                          return ProgrammeCard(
                            programme: t,
                            clientName: clientName,
                            technicienName: technicienName,
                            onEdit: () => _openProgrammeFormForTask(t),
                            onDelete: () async {
                              await ProgrammeService.deleteTask(t.id);
                              await _loadAllData();
                            },
                            onGeneratePdf: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              try {
                                debugPrint(
                                  '[PDF] Génération pour: titre=${t.titre}, date=${t.date}, client=$clientName, technicien=$technicienName, tel=${t.telephone}, adresse=${t.adresse}, commentaire=${t.commentaire}, heure=${t.heure}, type=${t.typeIntervention}, equipement=${t.equipement}',
                                );
                                final doc = pw.Document();
                                doc.addPage(
                                  pw.Page(
                                    build: (pw.Context context) => pw.Center(
                                      child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            'Fiche Intervention',
                                            style: pw.TextStyle(
                                              fontSize: 24,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                          pw.SizedBox(height: 16),
                                          pw.Table(
                                            border: pw.TableBorder.all(
                                              width: 1,
                                            ),
                                            columnWidths: {
                                              0: const pw.FlexColumnWidth(2),
                                              1: const pw.FlexColumnWidth(4),
                                            },
                                            children: [
                                              pw.TableRow(
                                                children: [
                                                  pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.all(
                                                          4,
                                                        ),
                                                    child: pw.Text(
                                                      'Titre',
                                                      style: pw.TextStyle(
                                                        fontWeight:
                                                            pw.FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.all(
                                                          4,
                                                        ),
                                                    child: pw.Text(t.titre),
                                                  ),
                                                ],
                                              ),
                                              pw.TableRow(
                                                children: [
                                                  pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.all(
                                                          4,
                                                        ),
                                                    child: pw.Text(
                                                      'Date',
                                                      style: pw.TextStyle(
                                                        fontWeight:
                                                            pw.FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.all(
                                                          4,
                                                        ),
                                                    child: pw.Text(
                                                      t.date.toString().split(
                                                        ' ',
                                                      )[0],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              pw.TableRow(
                                                children: [
                                                  pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.all(
                                                          4,
                                                        ),
                                                    child: pw.Text(
                                                      'Client',
                                                      style: pw.TextStyle(
                                                        fontWeight:
                                                            pw.FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.all(
                                                          4,
                                                        ),
                                                    child: pw.Text(clientName),
                                                  ),
                                                ],
                                              ),
                                              pw.TableRow(
                                                children: [
                                                  pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.all(
                                                          4,
                                                        ),
                                                    child: pw.Text(
                                                      'Technicien',
                                                      style: pw.TextStyle(
                                                        fontWeight:
                                                            pw.FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.all(
                                                          4,
                                                        ),
                                                    child: pw.Text(
                                                      technicienName,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (t.telephone != null &&
                                                  t.telephone!.isNotEmpty)
                                                pw.TableRow(
                                                  children: [
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        'Téléphone',
                                                        style: pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        t.telephone!,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              if (t.adresse != null &&
                                                  t.adresse!.isNotEmpty)
                                                pw.TableRow(
                                                  children: [
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        'Adresse',
                                                        style: pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        t.adresse!,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              if (t.commentaire != null &&
                                                  t.commentaire!.isNotEmpty)
                                                pw.TableRow(
                                                  children: [
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        'Commentaire',
                                                        style: pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        t.commentaire!,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              if (t.heure != null &&
                                                  t.heure!.isNotEmpty)
                                                pw.TableRow(
                                                  children: [
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        'Heure',
                                                        style: pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        t.heure ?? '',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              if (t.typeIntervention != null &&
                                                  t
                                                      .typeIntervention!
                                                      .isNotEmpty)
                                                pw.TableRow(
                                                  children: [
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        'Type',
                                                        style: pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        t.typeIntervention!,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              if (t.equipement != null &&
                                                  t.equipement!.isNotEmpty)
                                                pw.TableRow(
                                                  children: [
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        'Équipement',
                                                        style: pw.TextStyle(
                                                          fontWeight: pw
                                                              .FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    ),
                                                    pw.Padding(
                                                      padding:
                                                          const pw.EdgeInsets.all(
                                                            4,
                                                          ),
                                                      child: pw.Text(
                                                        t.equipement!,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                final pdfBytes = await doc.save();
                                String? path = await _showSaveFileDialog(
                                  context,
                                  'fiche_intervention.pdf',
                                );
                                if (path != null && pdfBytes.isNotEmpty) {
                                  final file = File(path);
                                  await file.writeAsBytes(pdfBytes);
                                  debugPrint('[PDF] Sauvegardé à : $path');
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'PDF enregistré à : $path',
                                        ),
                                      ),
                                    );
                                  }
                                } else if (path == null) {
                                  debugPrint(
                                    '[PDF] Sauvegarde annulée par l’utilisateur',
                                  );
                                } else {
                                  debugPrint(
                                    '[PDF] Erreur : PDF vide ou non généré',
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Erreur : PDF non généré',
                                        ),
                                      ),
                                    );
                                  }
                                }
                                debugPrint(
                                  '[PDF] Génération et sauvegarde terminées',
                                );
                              } catch (e, stack) {
                                debugPrint('[PDF] Erreur: $e\n$stack');
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erreur lors de la génération du PDF : $e',
                                    ),
                                  ),
                                );
                              } finally {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

Future<String?> _showSaveFileDialog(
  BuildContext context,
  String defaultName,
) async {
  String? filePath;
  await showDialog(
    context: context,
    builder: (context) {
      final controller = TextEditingController(text: defaultName);
      return AlertDialog(
        title: const Text('Enregistrer le PDF'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nom du fichier'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              filePath = controller.text.endsWith('.pdf')
                  ? controller.text
                  : controller.text + '.pdf';
              Navigator.of(context).pop();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      );
    },
  );
  return filePath;
}
