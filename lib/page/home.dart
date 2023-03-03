import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fs/page/monitoring.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hallo There's"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MonitoringPage()),
            ),
            child: Container(
              height: 76,
              margin: const EdgeInsets.all(16),
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Monitoring",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance.ref("/").onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dataMap = (snapshot.data?.snapshot.value ??
                      {
                        "IsOnKipas": false,
                        "IsOnLampu": false,
                        "IsOnPompa": false,
                        "Mode": false,
                      }) as Map;

                  return Column(
                    children: [
                      switchListTile(
                        dataMap['IsOnKipas'] ?? false,
                        'IsOnKipas',
                        'Kipas',
                        dataMap['Mode']
                      ),
                      switchListTile(
                        dataMap['IsOnLampu'] ?? false,
                        'IsOnLampu',
                        'Lampu',
                        dataMap['Mode']
                      ),
                      switchListTile(
                        dataMap['IsOnPompa'] ?? false,
                        'IsOnPompa',
                        'Pompa',
                        dataMap['Mode']
                      ),
                      const SizedBox(height: 40,),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseDatabase.instance.ref("/").update(
                            {
                              'Mode': !dataMap['Mode'],
                            },
                          );
                        },
                        child: Text(dataMap['Mode'] ? "Otomatis" : 'Manual'),
                      )
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Card switchListTile(bool value, String key, String title,bool mode) {
    return Card(
      child: SwitchListTile(
        value: value,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onChanged: mode ? null: (value) {
          FirebaseDatabase.instance.ref("/").update({key: value});
        } ,
      ),
    );
  }
}
