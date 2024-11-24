import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  late final int gutPercentage;
  late final int skinPercentage;
  late final int kidneyPercentage;
  late final int heartPercentage;
  late final String bestKidney;
  late final String bestSkin;
  late final String bestGut;
  late final String bestHeart;
  late final String worstKidney;
  late final String worstSkin;
  late final String worstGut;
  late final String worstHeart;

  ReportScreen({Key? key, required this.report}) : super(key: key) {
    gutPercentage = (((report['stomach'][0] as num)) * 100).toInt();
    skinPercentage = (((report['skin'][0] as num)) * 100).toInt();
    kidneyPercentage = (((report['kidney'][0] as num)) * 100).toInt();
    heartPercentage = (((report['heart'][0] as num)) * 100).toInt();
    bestKidney = report['kidney'][1];
    worstKidney = report['kidney'][2];
    bestSkin = report['skin'][1];
    worstSkin = report['skin'][2];
    bestGut = report['stomach'][1];
    worstGut = report['stomach'][2];
    bestHeart = report['heart'][1];
    worstHeart = report['heart'][2];
  }

  Widget buildReportSection(
      String title, String best, String worst, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(254, 247, 255, 1),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            spreadRadius: 0.01,
            offset: Offset(4, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                child: Text(
                  "$title ❤️: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    children: [
                      TextSpan(
                        text: "The scanned product contains ",
                      ),
                      TextSpan(
                        text: "$best",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text:
                            " which is relatively safe for your $title. Consuming ",
                      ),
                      TextSpan(
                        text: "$best",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: " will help you in maintaining a healthy $title.",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    children: [
                      TextSpan(
                        text: "The scanned product contains ",
                      ),
                      TextSpan(
                        text: "$worst",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text:
                            " which is relatively bad for your $title. Consuming ",
                      ),
                      TextSpan(
                        text: "$worst",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: " might lead to $title-related issues.",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(int percentage) {
      if (percentage > 70) {
        return Colors.green;
      } else if (percentage < 30) {
        return Colors.red;
      } else {
        return Colors.orange[300]!;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 20, left: 16, right: 16, bottom: 10),
                    margin: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Colors.black54,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "👋 Hello Vardh",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  AssetImage('assets/images/fab/profile.jpeg'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Your product report:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      height: 300,
                      width: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Vertical Line
                          Positioned.fill(
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.grey[400],
                            ),
                          ),
                          // Horizontal Line
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          // Gut Section
                          Positioned(
                            top: 40,
                            left: 60,
                            child: Column(
                              children: [
                                const Text(
                                  "Gut",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  // "$gutPercentage%" ,
                                  gutPercentage == -100
                                      ? "N/A"
                                      : "$gutPercentage%",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: getColor(gutPercentage),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Heart Section
                          Positioned(
                            top: 40,
                            right: 60,
                            child: Column(
                              children: [
                                const Text(
                                  "Heart",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  heartPercentage == -100
                                      ? "N/A"
                                      : "$heartPercentage%",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: getColor(skinPercentage)),
                                ),
                              ],
                            ),
                          ),
                          // Skin Section
                          Positioned(
                            bottom: 40,
                            left: 60,
                            child: Column(
                              children: [
                                const Text(
                                  "Skin",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  skinPercentage == -100
                                      ? "N/A"
                                      : "$skinPercentage%",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: getColor(skinPercentage)),
                                ),
                              ],
                            ),
                          ),
                          // Kidney Section
                          Positioned(
                            bottom: 40,
                            right: 60,
                            child: Column(
                              children: [
                                const Text(
                                  "Kidney",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  kidneyPercentage == -100
                                      ? "N/A"
                                      : "$kidneyPercentage%",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: getColor(kidneyPercentage),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Center Circle
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[400],
                    indent: 30,
                    endIndent: 30,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Detailed Report:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (gutPercentage != -100)
                    buildReportSection(
                        "Gut", bestGut, worstGut, getColor(gutPercentage)),
                  if (heartPercentage != -100)
                    buildReportSection("Heart", bestHeart, worstHeart,
                        getColor(heartPercentage)),
                  if (skinPercentage != -100)
                    buildReportSection(
                        "Skin", bestSkin, worstSkin, getColor(skinPercentage)),
                  if (kidneyPercentage != -100)
                    buildReportSection("Kidney", bestKidney, worstKidney,
                        getColor(kidneyPercentage)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
