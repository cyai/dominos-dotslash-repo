import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'menstrualCycleScreen.dart';
import 'package:http/http.dart' as http;
import 'reportScreen.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;

  const HomeScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isTorchOn = false;
  File? _selectedImage;
  bool _isLoading = false;

  final Map<String, List<String>> funFacts = {
    "Heart Health": [
      "- Chocolate loves your heart! Dark chocolate (70% cocoa or more) helps blood flow and reduces stress.",
      "- Tuna contains high amounts of mercury which can have a negative impact on your motor skills if consumed regularly. But, it is very good for heart as it provides fiber and reduced sodium content.",
      "- Your heart loves nuts, but be careful with the salty ones—they're a mixed signal for your arteries.",
      "- Strawberries are heart-shaped for a reason. Their vitamin C and antioxidants keep your heart smiling.",
      "- Pomegranate juice is a heart elixir. It reduces artery plaque and improves blood flow."
    ],
    "Kidney": [
      "- Watermelon is like a kidney car wash! Its high water content helps flush out toxins.",
      "- Basil tea keeps your kidneys clean. It acts as a natural detoxifier and helps prevent kidney stones.",
      "- Coconut water hydrates your kidneys naturally. It's low in calories and helps prevent kidney stones."
    ],
    "Skin": [
      "- Almonds are like sunscreen snacks. Their vitamin E protects your skin from UV damage.",
      "- Chia seeds are hydration heroes. They're rich in omega-3s that keep your skin plump and healthy.",
      "- Sweet potatoes are natural skin brighteners. Their beta-carotene enhances your skin's glow.",
      "- Honey is sweet for your skin. Whether eaten or applied, it locks in moisture and soothes irritation."
    ],
    "Gut Health": [
      "- Red wine = gut's best friend! A small glass feeds your gut microbes with polyphenols.",
      "- Coffee boost! It helps grow good bacteria and kickstarts digestion—perfect pre-meal fuel.",
      "- Leftover fried rice = gut magic! Cool it down, and it turns into resistant starch for your gut bacteria."
    ],
  };

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleTorch() async {
    if (_controller.value.isInitialized) {
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
      await _controller.setFlashMode(
        _isTorchOn ? FlashMode.torch : FlashMode.off,
      );
    }
  }

  Future<void> takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      await _processImage(File(image.path));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _processImage(File(pickedFile.path));
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // get report
      final response = await http.post(
        Uri.parse("http://10.1.17.246:5001/processing"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"base64_data": base64Image}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReportScreen(report: responseData)),
        );
        print("Response: $responseData");
      } else {
        print("Error: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to process image. Try again.")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Try again.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  late BuildContext _dialogContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dialogContext = context;
  }

  void showRandomFactDialog() {
    final randomCategory = (funFacts.keys.toList()..shuffle()).first;
    final randomFact = (funFacts[randomCategory]!..shuffle()).first;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Timer(Duration(seconds: 5), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "$randomCategory:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0, top: 8.0, left: 16.0, right: 8.0),
                    child: Text("$randomFact"),
                  ),
                ],
              ),
              Positioned(
                top: 16,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Icon(Icons.close, color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTapFocus(TapDownDetails details, BoxConstraints constraints) {
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    _controller.setFocusPoint(offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // navbar
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenstrualCycleScreen()),
                        );
                      },
                      // child: const Icon(
                      //   Icons.info_outline,
                      //   size: 24,
                      //   color: Colors.black54,
                      // ),
                      child: Image.asset(
                        'assets/images/fab/woman.jpg',
                        width: 54,
                        height: 54,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return GestureDetector(
                          onTapDown: (details) =>
                              _onTapFocus(details, constraints),
                          child: Stack(
                            children: [
                              FutureBuilder<void>(
                                future: _initializeControllerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: CameraPreview(_controller),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: Icon(
                                    _isTorchOn
                                        ? Icons.flash_on
                                        : Icons.flash_off,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: toggleTorch,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: takePicture,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                      ),
                      child: const Text(
                        "Take Pic",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 28),
                    OutlinedButton(
                      onPressed: _pickImageFromGallery,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/fab/upload.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: 20), // Add some space between the buttons and the box
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
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
                    const Text(
                      "Tips: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Scan the ingredients list on the back of the product to get the health effects after consuming them.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    // Add more content here
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
