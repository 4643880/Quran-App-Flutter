import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quran_app/controllers/controller.dart';
import 'package:quran_app/models/model.dart';
import 'package:quran_app/screens/surah_list_screen.dart';
import 'dart:developer' as devtools show log;
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:audioplayers/audioplayers.dart';

class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  FlutterTts flutterTts = FlutterTts();
  bool isLoading = false;
  QuranResponse? quranResponse;
  String translated = "Translation";
  RxInt surahCounter = 0.obs;
  RxInt ayatCounter = 0.obs;

  Future speak({required String str}) async {
    await flutterTts.setLanguage('ar-SA');
    await flutterTts.setVolume(1);
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.2);
    await flutterTts.speak(str);
  }

  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  @override
  void initState() {
    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }
    callApi();
    super.initState();
  }

  callApi() async {
    try {
      setState(() {
        isLoading = true;
      });
      var url = "http://api.alquran.cloud/v1/quran/quran-uthmani";
      var response = await http.get(Uri.parse(url));
      var stringResponse = response.body;
      if (response.statusCode == 200) {
        devtools.log("alpha: " + stringResponse.toString());
        var decodedJson = jsonDecode(stringResponse);
        devtools.log(decodedJson.toString());
        setState(() {
          quranResponse = QuranResponse.fromJson(decodedJson);
        });
        await translateApi();
        setState(() {
          isLoading = false;
        });
      } else {
        devtools.log("Status is not 200");
      }
    } catch (e) {
      setState(() {
        quranResponse = null;
        isLoading = false;
      });
      devtools.log(e.toString());
    }
  }

  translateApi() async {
    // devtools.log("1");
    const apiKey = 'AIzaSyBiwLAwKZm2l3RR0ksWaw_fL-1F7kZ6Iv0';
    const to = 'en';
    final url =
        "https://translation.googleapis.com/language/translate/v2?q=${quranResponse!.data.surahs[surahCounter.value].ayahs[ayatCounter.value].text}&target=$to&key=$apiKey";
    final response = await http.post(Uri.parse(url));
    final translation = await quranResponse!.data.surahs[0].ayahs[0].text
        .translate(from: 'ar', to: 'en');
    // devtools.log("2");
    if (response.statusCode == 200) {
      devtools.log("3");
      final decodedBody = jsonDecode(response.body);
      final translations =
          decodedBody["data"]["translations"][0]["translatedText"];
      devtools.log(translations.toString());
      setState(() {
        translated = translations;
      });
    } else {
      devtools.log("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    MyController controller = Get.put(MyController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Restricting to horizontal device orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // callApi();
    return SafeArea(
      child: isLoading == false
          ? Scaffold(
              backgroundColor: const Color(0xfffcfcfc),
              body: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              // color: Colors.blue,
                              child: const Text(
                                "Daily Quran",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerRight,
                              width: double.infinity,
                              // color: Colors.blue,
                              child: Obx(
                                () => Text(
                                  quranResponse!.data.surahs[surahCounter.value]
                                      .ayahs[ayatCounter.value].text,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              height: 2,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              // color: Colors.blue,
                              child: Text(
                                translated,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: screenHeight * 0.28,
                      decoration: BoxDecoration(
                        // color: Colors.orange,
                        border: Border.all(
                          color: const Color(0xffc7d1d9),
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        // shape: BoxShape.circle,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: -10,
                                  child: CircularButton(
                                    function: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => MySurahList(
                                            quranResponse: quranResponse!),
                                      ));
                                    },
                                    icon: Icons.menu,
                                  ),
                                ),
                                Positioned(
                                  left:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if ((ayatCounter.value) >= 1) {
                                        ayatCounter.value--;
                                        // devtools.log(ayatCounter.value.toString());
                                        // devtools.log("len of ayat" + quranResponse!.data.surahs[surahCounter.value]
                                        //     .ayahs.length.toString());
                                        await translateApi();
                                      } else if ((surahCounter.value) >= 1) {
                                        surahCounter.value--;
                                        // ayatCounter.value = 0;
                                        await translateApi();
                                      }
                                      // quranResponse!.data.surahs[surahCounter.value]
                                      //     .ayahs[ayatCounter.value].text
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffc7d1d9),
                                            width: 2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(3.14),
                                          child: SvgPicture.asset(
                                            "assets/images/Vector.svg",
                                            height: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if ((ayatCounter.value) <
                                          (quranResponse!
                                                  .data
                                                  .surahs[surahCounter.value]
                                                  .ayahs
                                                  .length -
                                              1)) {
                                        ayatCounter.value++;
                                        // devtools.log(ayatCounter.value.toString());
                                        // devtools.log("len of ayat" + quranResponse!.data.surahs[surahCounter.value]
                                        //     .ayahs.length.toString());
                                        await translateApi();
                                      } else if ((surahCounter.value) <
                                          quranResponse!.data.surahs.length -
                                              1) {
                                        surahCounter.value++;
                                        ayatCounter.value = 0;
                                        await translateApi();
                                      }
                                      // quranResponse!.data.surahs[surahCounter.value]
                                      //     .ayahs[ayatCounter.value].text
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.20,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffc7d1d9),
                                            width: 2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SvgPicture.asset(
                                          "assets/images/Vector.svg",
                                          height: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () async {
                                      await speak(str: quranResponse!.data.surahs[surahCounter.value]
                                          .ayahs[ayatCounter.value].text);

                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.33,
                                      width: MediaQuery.of(context).size.width *
                                          0.33,
                                      // margin: const EdgeInsets.only(bottom: 35),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xffc7d1d9),
                                            width: 2,
                                          ),
                                          shape: BoxShape.circle,
                                          color: Colors.blue),
                                      // padding: const EdgeInsets.only(
                                      //     bottom: 4, right: 3),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Container(
                                          child: SvgPicture.asset(
                                            "assets/images/fi-rr-play.svg",
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -10,
                                  child: GetBuilder<MyController>(
                                    builder: (controller) => CircularButton(
                                      color: Get.find<MyController>().selectedAyahsList2
                                          .contains(quranResponse!
                                          .data
                                          .surahs[surahCounter.value]
                                          .ayahs[ayatCounter.value]
                                          .number)
                                          ? Colors.green
                                          : null,
                                      iconColor: Get.find<MyController>().selectedAyahsList2
                                          .contains(quranResponse!
                                          .data
                                          .surahs[surahCounter.value]
                                          .ayahs[ayatCounter.value]
                                          .number)
                                          ? Colors.white
                                          : null,
                                      function: () {
                                        if(controller.selectedAyahsList2.contains(quranResponse!
                                            .data
                                            .surahs[surahCounter.value]
                                            .ayahs[ayatCounter.value]
                                            .number)){
                                          null;
                                        }else{
                                          controller.setAddSelected2(quranResponse!
                                              .data
                                              .surahs[surahCounter.value]
                                              .ayahs[ayatCounter.value]
                                              .number);
                                        }
                                        devtools.log(quranResponse!
                                            .data
                                            .surahs[surahCounter.value]
                                            .ayahs[ayatCounter.value]
                                            .number.toString());
                                        devtools.log("abc" + controller.selectedAyahsList2.length.toString());
                                      },

                                      icon: Icons.check,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  quranResponse!.data.surahs[surahCounter.value]
                                      .englishName
                                      .toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Surah ${quranResponse!.data.surahs[surahCounter.value].number.toString()}",
                                      style: const TextStyle(
                                        fontSize: 08,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 03),
                                      child: Text(
                                        "|",
                                        style: TextStyle(),
                                      ),
                                    ),
                                    Text(
                                      "Verse ${ayatCounter.value + 1}/${quranResponse!.data.surahs[surahCounter.value].ayahs.length}",
                                      style: TextStyle(
                                        fontSize: 08,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final Color? iconColor;
  final Function() function;

  const CircularButton({
    super.key,
    this.icon,
    required this.function,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: GetBuilder<MyController>(
        builder: (controller) => Container(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width * 0.20,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: const Color(0xffc7d1d9), width: 2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: function,
            icon: Icon(
              icon,
              size: 45,
              color: iconColor ?? const Color(0xff021229),
            ),
          ),
        ),
      ),
    );
  }
}
