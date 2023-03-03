import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String history = "Cahaya";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref("/History").onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cahaya =
                ((snapshot.data?.snapshot.value as Map)['Cahaya'] as Map);
            final kelembapan =
                (snapshot.data?.snapshot.value as Map)['Kelembapan'] as Map;
            final suhu =
                (snapshot.data?.snapshot.value as Map)['Suhu'] as Map;

            final listTileCahaya = cahaya.entries.map((e) {
              final data = e.key.toString().split("Jam:");
              final jam = data[1];
              final tggl = data[0].split("Tgl:").join('');
              // log(tggl.toString());
              return ListTile(
                title: Text(jam),
                subtitle: Text(tggl),
                trailing: Text(e.value + " lux"),
              );
            }).toList();

            final listTileKelembapan = kelembapan.entries.map((e) {
              final data = e.key.toString().split("Jam:");
              final jam = data[1];
              final tggl = data[0].split("Tgl:").join('');

              return ListTile(
                 title: Text(jam),
                subtitle: Text(tggl),
                trailing: Text(e.value + "%"),
              );
            }).toList();

            final listTileSuhu = suhu.entries.map((e) {
              final data = e.key.toString().split("Jam:");
              final jam = data[1];
              final tggl = data[0].split("Tgl:").join('');

              return ListTile(
                 title: Text(jam),
                subtitle: Text(tggl),
                trailing: Text("${int.parse(e.value.toString())}°"),
              );
            }).toList();

            final listData = {
              "Suhu" : listTileSuhu,
              "Cahaya" : listTileCahaya,
              "Kelembapan" : listTileKelembapan,
            };

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buttonHistory('Cahaya'),
                      buttonHistory('Kelembapan'),
                      buttonHistory('Suhu'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: listData[history]!
                  ),
                ),
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

  OutlinedButton buttonHistory(String pilihan) {
    return OutlinedButton(
      onPressed: () {
        history = pilihan;
        setState(() {});
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: history == pilihan ? null : Colors.grey,
      ),
      child: Text(pilihan),
    );
  }
}
