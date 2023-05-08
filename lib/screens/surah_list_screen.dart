import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/controller.dart';
import 'package:quran_app/screens/complete_surah_screen.dart';

import '../models/model.dart';

class MySurahList extends StatelessWidget {
  final QuranResponse quranResponse;
  const MySurahList({super.key, required this.quranResponse});

  @override
  Widget build(BuildContext context) {
    MyController controller = MyController();
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
          "Surah List",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: quranResponse.data.surahs.length,
              itemBuilder: (context, index) {
                var currentSurah = quranResponse.data.surahs[index];
                return Column(
                  children: [
                    Card(
                      elevation: 0,
                      color: const Color(0xfffcfcfc),
                      child: Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          trailing: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xff42597A),
                            size: 30,
                          ),
                          title: GestureDetector(
                            onTap: () {
                              Get.to(CompleteSurah(currentSurah: currentSurah));
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    currentSurah.englishName.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Container(
                                  // color: Colors.blue,
                                  // width: 175,
                                  height: 45,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xffc7d1d9),
                                              width: 2,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Icon(
                                              Icons.check,
                                              size: 25,
                                              color: Color(0xff021229),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(
                                        color: Color(0xffc7d1d9),
                                        thickness: 2,
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          children: [
                            // height: 45 * double.parse(currentSurah.ayahs.length.toString() )
                            Container(
                              height: 45 * double.parse(currentSurah.ayahs.length.toString() ),
                              child: Column(
                                children: [
                                  Expanded(
                                    // height: currentSurah.ayahs.length >= 5 ? 45 * 5 : 45 * double.parse(currentSurah.ayahs.length.toString() ),
                                    // height: 45 * double.parse(currentSurah.ayahs.length.toString() ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: currentSurah.ayahs.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: 45,
                                          padding: const EdgeInsets.only(left: 45, right: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Verse  ${currentSurah.ayahs[index].numberInSurah}"),
                                              const Spacer(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(right: 10),
                                                child: GetBuilder<MyController>(
                                                  builder: (controller) => Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: controller.selectedAyahsList2
                                                          .contains(currentSurah.ayahs[index]
                                                          .number)
                                                          ? Colors.green
                                                          : null,
                                                      border: Border.all(
                                                        color: const Color(0xffc7d1d9),
                                                        width: 2,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(4.0),
                                                      child: Icon(
                                                        Icons.check,
                                                        size: 20,
                                                        color: controller.selectedAyahsList2
                                                            .contains(currentSurah.ayahs[index]
                                                            .number)
                                                            ? Colors.white
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                      // thickness: ,
                      color: Colors.black,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
