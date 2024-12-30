import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const AlarmReminderApp());
}

class AlarmReminderApp extends StatelessWidget {
  const AlarmReminderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlarmReminderScreen(),
    );
  }
}

class AlarmReminderScreen extends StatefulWidget {
  @override
  _AlarmReminderScreenState createState() => _AlarmReminderScreenState();
}

class _AlarmReminderScreenState extends State<AlarmReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final List<Map<String, String>> _reminders = [];

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final formattedTime = picked.format(context);
        _timeController.text = formattedTime;
      });
    }
  }

  void _addReminder() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _reminders.add({
          'name': _nameController.text,
          'dose': _doseController.text,
          'time': _timeController.text,
        });
        _nameController.clear();
        _doseController.clear();
        _timeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Title inside the card to have shadow together with the form
                const Text(
                  'Alarm Pengingat Minum Obat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Obat',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama obat wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _doseController,
                        decoration: const InputDecoration(
                          labelText: 'Dosis',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Dosis wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Waktu Pengingat',
                          hintText: 'Pilih waktu',
                          border: OutlineInputBorder(),
                        ),
                        onTap: _selectTime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Waktu pengingat wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Button color (orange)
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0), // Adjust padding for modern feel
                          textStyle: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: _addReminder,
                        child: const Text('Tambah Pengingat'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),  // Padding above "Daftar Pengingat"
                const Text(
                  'Daftar Pengingat:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _reminders.isEmpty
                      ? const Center(
                          child: Text('Belum ada pengingat.'),
                        )
                      : ListView.builder(
                          itemCount: _reminders.length,
                          itemBuilder: (context, index) {
                            final reminder = _reminders[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text('Nama Obat: ${reminder['name']}'),
                                subtitle: Text(
                                  'Dosis: ${reminder['dose']} Waktu: ${reminder['time']}',
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}