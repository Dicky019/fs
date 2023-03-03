import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fs/page/history.dart';

import '../rounded_widget.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoring"),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref("/").onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = (snapshot.data?.snapshot.value ??
                {
                  "Cahaya": 0,
                  "Suhu": 0,
                  "Kelembaban": 0,
                }) as Map;
            return Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Center(
                    child: Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: <Widget>[
                        RoundWidget(text: 'Suhu', value: "${data['Suhu']}°"),
                        RoundWidget(
                            text: 'Kelembaban \nTanah',
                            value: "${data['Kelembaban']}%"),
                        RoundWidget(
                            text: 'Intensitas \nCahaya',
                            value: "${data['Cahaya']} lux"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.history),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const History()),
                      ),
                      label: const Text('History'),
                    ),
                  ),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
