import 'package:flutter/material.dart';
import 'agenda.dart';
import 'agenda_service.dart';
import 'dart:ui';

class AgendaForm extends StatefulWidget {
  final Agenda? agenda;
  const AgendaForm({super.key, this.agenda});

  @override
  State<AgendaForm> createState() => _AgendaFormState();
}

class _AgendaFormState extends State<AgendaForm> {
  final _formKey = GlobalKey<FormState>();
  final _judul = TextEditingController();
  final _ket = TextEditingController();
  final _service = AgendaService();

  @override
  void initState() {
    super.initState();
    if (widget.agenda != null) {
      _judul.text = widget.agenda!.judul;
      _ket.text = widget.agenda!.keterangan;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final agenda = Agenda(
        id: widget.agenda?.id,
        judul: _judul.text,
        keterangan: _ket.text,
      );

      try {
        bool isEdit = widget.agenda != null;

        if (isEdit) {
          await _service.update(agenda.id!, agenda);
        } else {
          await _service.create(agenda);
        }

        // 🔔 NOTIF BERHASIL
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Agenda berhasil diperbarui ✏'
                  : 'Agenda berhasil disimpan ✔',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF0D47A1),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.pop(context, true);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal simpan: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.agenda == null ? 'Tambah Agenda' : 'Edit Agenda',
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFF8EC5FC),
              Color(0xFF4FC3F7),
              Color(0xFFA8E6CF),
            ],
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // INPUT JUDUL
                      TextFormField(
                        controller: _judul,
                        style: const TextStyle(
                          color: Color(0xFF0D47A1),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Judul',
                          labelStyle: TextStyle(color: Color(0xFF0D47A1)),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib isi judul' : null,
                      ),

                      const SizedBox(height: 10),

                      // INPUT KETERANGAN
                      TextFormField(
                        controller: _ket,
                        decoration: const InputDecoration(
                          labelText: 'Keterangan',
                          labelStyle: TextStyle(color: Color(0xFF1A237E)),
                        ),
                        style: const TextStyle(color: Color(0xFF1A237E)),
                      ),

                      const SizedBox(height: 25),

                      // TOMBOL SIMPAN
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          foregroundColor: Colors.blueAccent,
                          elevation: 6,
                          shadowColor: Colors.cyanAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.blueAccent.withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
