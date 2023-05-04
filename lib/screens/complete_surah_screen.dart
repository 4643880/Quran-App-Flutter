import 'package:flutter/material.dart';

import '../models/model.dart';

class CompleteSurah extends StatelessWidget {
  final Surahs currentSurah;

  const CompleteSurah({super.key, required this.currentSurah});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfcfc),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: const Text(
          "Complete Surah",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: currentSurah.ayahs.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.topRight,
                    padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                    child: Text(
                      currentSurah.ayahs[index].text.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      textAlign: TextAlign.right,
                    ),);
              },
            ),
          ),
        ],
      ),
    );
  }
}
