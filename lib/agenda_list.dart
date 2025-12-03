import 'package:flutter/material.dart';
import 'dart:ui';
import 'agenda.dart';
import 'agenda_form.dart';
import 'agenda_service.dart';


class AgendaList extends StatefulWidget {
  const AgendaList({super.key});

  @override
  State<AgendaList> createState() => _AgendaListState();
}

class _AgendaListState extends State<AgendaList> {
  final _service = AgendaService();
  late Future<List<Agenda>> _agendaList;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
  _agendaList = _service.getAll();
  setState(() {});
}


  void _delete(int id) async {
    await _service.delete(id);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
  title: Text(
    'Agenda App',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      color: Color(0xFF0D47A1),
      shadows: [
        Shadow(
          blurRadius: 12,
          color: Colors.white.withOpacity(0.9),
          offset: Offset(0, 0),
        ),
      ],
    ),
  ),
  centerTitle: true,
  elevation: 0,
  backgroundColor: Colors.transparent,
),


      body: 
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
            Color(0xFFFFFFFF), // putih awan
            Color(0xFF8EC5FC), // biru langit lembut
            Color(0xFF4FC3F7), // biru cerah
            Color(0xFFA8E6CF), // hijau lembut
           ],
          ),
        ),
        child: FutureBuilder<List<Agenda>>(
          future: _agendaList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Gagal memuat data: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final data = snapshot.data ?? [];
            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'Langit masih kosong 🌥\nBelum ada agenda hari ini',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
              itemCount: data.length,
              itemBuilder: (_, i) {
                final item = data[i];

                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          item.judul,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1), // biru tua navy
                         ),
                        ),
                        subtitle: Text(
                          item.keterangan,
                          style: const TextStyle(color: Color(0xFF1A237E)), // biru gelap
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AgendaForm(agenda: item),
                                  ),
                                );
                                if (result == true) _refresh();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _delete(item.id!),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 6,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgendaForm()),
          );
          if (result == true) _refresh();
        },
        child: const Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}
