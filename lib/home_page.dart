import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';

import 'about.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  final TextEditingController _textController = TextEditingController();
  int cnt = 0;
  String path = '';
  Color canvasColor = Colors.redAccent;
  Color textColor = Colors.black;
  ui.Image? image;
  Uint8List savingBuffer = Uint8List(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('স্বাধীনতা ক্যানভাস', style: TextStyle(fontFamily: 'AbuSayed')),
        backgroundColor: Colors.redAccent,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text('About'),
                  value: 'about',
                ),
              ];
            },
            onSelected: (value) {
              if(value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const About(),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (_imageFile == null)
              ? DottedBorder(
                color: Colors.black,
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: GestureDetector(
                  onTap: () {
                    buildShowDialog(context);
                  },
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 60),
                        Text('Choose a Canvas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ) : Stack(
                children: [
                  Container(
                  width: 300,
                  height: 300,
                  child: Image(
                      image: FileImage(_imageFile!),
                    fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        buildShowDialog(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter text',
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Text Color: ', style: TextStyle(fontSize: 20),),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Select a Color'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: textColor,
                                onColorChanged: (color) {
                                  setState(() {
                                    textColor = color;
                                  });
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Done'),
                              ),
                            ],
                          );
                        }
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: textColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _addTextToImage();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                    ),
                    child: const Text('Add Text', style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      saveToGallery();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Color(0xFFF6CCA9)),
                    ),
                    child: const Text('Save to Gallery'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                      'Select a Canvas',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            title: const Text('Create a Canvas'),
                                            content: SingleChildScrollView(
                                              child: ColorPicker(
                                                pickerColor: canvasColor,
                                                onColorChanged: (color) {
                                                  setState(() {
                                                    canvasColor = color;
                                                  });
                                                },
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  canvasImageMaker();
                                                },
                                                child: const Text('Done'),
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.yellow[800]
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add),
                                          SizedBox(width: 10),
                                          Text('Create a Canvas'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      imageFromGallery();
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.green[400],
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.file_open),
                                          SizedBox(width: 10),
                                          Text('Choose from Files'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      imageFromCamera();
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.red[300]
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.camera_alt_rounded),
                                          SizedBox(width: 10),
                                          Text('Take a Photo'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      );
  }

  Future imageFromGallery() async {
    final selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage == null) return;

    final Uint8List imageBytes = await selectedImage.readAsBytes();
    final ui.Image tempImage = await decodeImageFromList(imageBytes);
    setState(() {
      cnt++;
      _imageFile = File(selectedImage.path);
      image = tempImage;
    });
  }

  Future imageFromCamera() async {
    final selectedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (selectedImage == null) return;
    final Uint8List imageBytes = await selectedImage.readAsBytes();
    final ui.Image tempImage = await decodeImageFromList(imageBytes);
    setState(() {
      cnt++;
      _imageFile = File(selectedImage.path);
      image = tempImage;
    });
  }

  Future<void> canvasImageMaker() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    paint.color = canvasColor;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 800, 800), paint);
    final picture = recorder.endRecording();
    final img = await picture.toImage(800, 800);

    final Directory? directory = await getTemporaryDirectory();
    path = '${directory?.path}/image$cnt.png';
    final File file = File(path);
    await file.writeAsBytes((await img.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List());

    setState(() {
      cnt++;
      _imageFile = file;
      image = img;
    });
  }

  String textRefactor(String text, int length, double _fontSize,) {
    String newText = '', result = '';
    List<String> words = text.split(' ');
    for(int i=0; i<words.length; i++){
      newText = result + words[i];
      final textPainter = TextPainter(
        text: TextSpan(
          text: newText,
          style: TextStyle(
            fontSize: _fontSize,
            fontFamily: 'AbuSayed',
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      if(textPainter.width > length){
        result += '\n${words[i]} ';
      } else {
        result += '${words[i]} ';
      }
    }
    return result;
  }

  Future<void> _addTextToImage() async {
    if(_imageFile == null) return;
    // Permission.storage.request().isDenied.then((value){
    //   if(value){
    //     openAppSettings();
    //   }
    // });

    var imageWidth = image?.width;
    var imageHeight = image?.height;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    canvas.drawImage(image!, Offset.zero, paint);

    double _fontSize = imageWidth! / 10;

    String finalText = textRefactor(_textController.text, imageWidth - 30, _fontSize);

    final textPainter = TextPainter(
      text: TextSpan(
        text: finalText,
        style: TextStyle(
          color: textColor,
          fontSize: _fontSize,
          fontFamily: 'AbuSayed',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: null,
      ellipsis: '...',
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: imageWidth - 20,
    );
    double x = (imageWidth - textPainter.width) / 2;
    double y = (imageHeight! - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(x, y));

    final picture = recorder.endRecording();
    final img = await picture.toImage(imageWidth, imageHeight);

    final Directory directory = await getTemporaryDirectory();
    path = '${directory.path}/image$cnt.png';
    final File file = File(path);
    final buffer = (await img.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    await file.writeAsBytes(buffer);
    
    setState(() {
      cnt++;
      savingBuffer = buffer;
      _imageFile = file;
    });
  }

  Future<void> saveToGallery() async {
    await GallerySaver.saveImage(path, albumName: 'ShadhinotaCanvas');
    const snackBar = SnackBar(
      content: Text('Image saved to Gallery'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
