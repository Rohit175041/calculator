import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnit = "ca-app-pub-3940256099942544/6300978111"; //testing ad id
  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnit,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        }),
        request: const AdRequest());
    bannerAd.load();
  }

  String userInput = "";
  String result = "0";
  List<String> buttonList = [
    "AC",
    "(",
    ")",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "-",
    "C",
    "0",
    ".",
    "="
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.8,
              child: resultWidget(),
            ),
            Expanded(
              child: ButtonWidgit(),
            )
          ],
        ),
        // bottomNavigationBar: isAdLoaded
        //     ? SizedBox(
        //         height: bannerAd.size.height.toDouble(),
        //         width: bannerAd.size.width.toDouble(),
        //         child: AdWidget(ad: bannerAd),
        //       )
        //     : const SizedBox(
        //         child: Text(
        //           "  Simple Calculator",
        //           style: TextStyle(
        //               fontSize: 20,
        //               fontStyle: FontStyle.italic,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.grey),
        //         ),
        //       ),
      ),
    );
  }

  Widget resultWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
            alignment: Alignment.bottomRight,
            child: Text(userInput.characters.take(14).toString(), style: const TextStyle(fontSize: 32)),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
            alignment: Alignment.bottomRight,
            child: Text(result.characters.take(15).toString(),
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget ButtonWidgit() {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
        color: const Color.fromARGB(66, 233, 232, 232),
        child: GridView.builder(
            itemCount: buttonList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return button(buttonList[index]);
            }));
  }

  getColor(String text) {
    if (text == "/" ||
        text == "*" ||
        text == "+" ||
        text == "-" ||
        text == "C" ||
        text == "(" ||
        text == ")") {
      return Colors.redAccent;
    }
    if (text == "=" || text == "AC") {
      return Colors.white;
    }
    return Colors.black;
  }

  getBgColor(String text) {
    if (text == "AC") {
      return Colors.redAccent;
    }
    if (text == "=") {
      return const Color.fromARGB(255, 104, 204, 159);
    }
    return Colors.white;
  }

  Widget button(String text) {
    return InkWell(
      onTap: () {
        setState(() {
          handleButtonPress(text);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: getBgColor(text),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1,
              )
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: getColor(text),
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
        ),
      ),
    );
  }

  handleButtonPress(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      return;
    }
    if (text == "C") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return null;
      }
    }
    if (text == "=") {
      result = calculate();
      userInput = result;
      if (userInput.endsWith(".0")) {
        userInput = userInput.replaceAll((".0"), "");
      }
      return;
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evolution = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evolution.toString();
    } catch (e) {
      return "Error";
    }
  }
}
