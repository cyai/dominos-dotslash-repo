import 'package:flutter/material.dart';

class MenstrualCycleScreen extends StatefulWidget {
  @override
  _MenstrualCycleScreenState createState() => _MenstrualCycleScreenState();
}

class _MenstrualCycleScreenState extends State<MenstrualCycleScreen> {
  String? selectedPhase;
  final phaseData = {
    "follicular_phase": {
      "title": "Follicular Phase",
      "good": [
        "Leafy greens (spinach, kale)",
        "Berries",
        "Avocados",
        "Whole grains",
        "Lean proteins (chicken, tofu)",
        "Nuts and seeds"
      ],
      "bad": ["Processed foods", "Sugary snacks", "High-fat foods", "Caffeine"]
    },
    "ovulation_phase": {
      "title": "Ovulation Phase",
      "good": [
        "Berries",
        "Eggs",
        "Cruciferous vegetables (broccoli, cauliflower)",
        "Chia seeds"
      ],
      "bad": ["Refined carbs", "Fried foods", "Excessive dairy"]
    },
    "luteal_phase": {
      "title": "Luteal Phase",
      "good": [
        "Complex carbs (sweet potatoes, oats)",
        "Magnesium-rich foods (bananas, almonds)",
        "Lean proteins",
        "Dark chocolate"
      ],
      "bad": [
        "Sugary foods",
        "Salt-heavy foods",
        "Caffeine in excess",
        "Processed snacks"
      ]
    },
    "menstrual_phase": {
      "title": "Menstrual Phase",
      "good": [
        "Iron-rich foods (red meat, lentils)",
        "Hydrating foods (cucumbers, watermelon)",
        "Herbal teas",
        "Ginger"
      ],
      "bad": ["Caffeine", "Sugary foods", "Alcohol", "Processed meat"]
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFECD8D6),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
            const Text(
              "Choose Infradian Rhythm:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/fab/phases.png',
                  height: 400,
                  width: 400,
                  fit: BoxFit.contain,
                ),
                // Clickable Quadrants
                Positioned(
                  top: 40,
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => selectedPhase = "menstrual_phase"),
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  right: 40,
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => selectedPhase = "follicular_phase"),
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  child: GestureDetector(
                    onTap: () => setState(() => selectedPhase = "luteal_phase"),
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  left: 40,
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => selectedPhase = "ovulation_phase"),
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(
              thickness: 2,
              color: Colors.grey[400],
              indent: 30,
              endIndent: 30,
            ),
            const SizedBox(height: 10),
            if (selectedPhase != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phaseData[selectedPhase]!['title'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Good Foods:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...(phaseData[selectedPhase]!['good'] as List<String>)
                          .map<Widget>((item) => Text("- $item"))
                          .toList(),
                      const SizedBox(height: 10),
                      const Text(
                        "Bad Foods:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...(phaseData[selectedPhase]!['bad'] as List<String>)
                          .map<Widget>((item) => Text("- $item"))
                          .toList(),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
