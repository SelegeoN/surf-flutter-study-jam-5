import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:meme_generator/widgets/custom_text_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../widgets/custom_painter_demotivator.dart';

class CustomPainterWidget extends StatefulWidget {
  const CustomPainterWidget({super.key});

  @override
  State<CustomPainterWidget> createState() => _CustomPainterWidgetState();
}

class _CustomPainterWidgetState extends State<CustomPainterWidget> {
  bool isFromFile = false;
  final _urlController = TextEditingController();
  final _headerController = TextEditingController();
  final _bodyController = TextEditingController();
  ui.Image? imageInWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Загрузка из файла?',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: isFromFile,
                        activeColor: Colors.white,
                        onChanged: (bool value) {
                          setState(() {
                            imageInWidget = null;
                            _headerController.text = '';
                            _bodyController.text = '';
                            isFromFile = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                imageInWidget.runtimeType == ui.Image
                    ? CustomPaint(
                        painter: MyCustomPainter(
                            color: Colors.white,
                            image: imageInWidget,
                            header: _headerController.text,
                            body: _bodyController.text),
                        child: Container(
                          height: 350,
                          width: 370,
                        ),
                      )
                    : Container(
                        height: 350,
                        child: const Center(
                          child: Text(
                            'Введите ссылку или выберите картинку для появления демотиватора',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                isFromFile == true
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: IconButton(
                              onPressed: () async {
                                await pickImageFromGallery();
                              },
                              icon: const Icon(Icons.file_upload)),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: CustomTextField(
                          onSubmitted: (val) async {
                            await loadImageFromNetwork(val);
                          },
                          hint: 'Введите ссылку на картинку',
                          style: const TextStyle(color: Colors.white),
                          controller: _urlController,
                        )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: CustomTextField(
                      onChanged: (val) {
                        setState(() {});
                      },
                      hint: 'Введите заголовок',
                      style: const TextStyle(color: Colors.white),
                      controller: _headerController,
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: CustomTextField(
                      onChanged: (val) {
                        setState(() {});
                      },
                      hint: 'Введите описание',
                      style: const TextStyle(color: Colors.white),
                      controller: _bodyController,
                    )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: imageInWidget.runtimeType == ui.Image
          ? FloatingActionButton(
              child: const Icon(Icons.download_outlined),
              onPressed: () async {
                ui.Image image = await getImage();
                ByteData? byteData = await (image.toByteData(
                  format: ui.ImageByteFormat.png,
                ));
                writeToFile(byteData);
              },
            )
          : const SizedBox(),
    );
  }

  Future pickImageFromGallery() async {//функция для получения картинки из галлереи
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'heic'],
      );
      File imageFile = File(res!.files.first.path!);
      Uint8List bytes = await imageFile.readAsBytes();
      ui.Image image = await loadImageFromBytes(bytes);
      imageInWidget = image;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future loadImageFromNetwork(String imagePath) async {
    Response response = await get(
      Uri.parse(imagePath),
    );
    Uint8List bytes = response.bodyBytes;
    ui.Image image = await loadImageFromBytes(bytes);
    imageInWidget = image;
    setState(() {});
  }

  Future<ui.Image> loadImageFromBytes(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<ui.Image> getImage() async {
    MyCustomPainter myPainter = MyCustomPainter(
        color: Colors.white,
        image: imageInWidget,
        header: _headerController.text,
        body: _bodyController.text);
    double containerWidth = 370;
    double containerHeight = 350;
    ui.Size size = ui.Size(containerWidth, containerHeight);
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    myPainter.paint(Canvas(recorder), size);
    final ui.Picture picture = recorder.endRecording();
    return await picture.toImage(int.parse(containerWidth.floor().toString()),
        int.parse(containerHeight.floor().toString()));
  }

  Future<void> writeToFile(ByteData? data) async {
    String path = '/storage/emulated/0/Download';
    final Directory? downloadsDir = await getDownloadsDirectory();
    final buffer = data!.buffer; // Permission.manageExternalStorage
    await Permission.manageExternalStorage.request();
    var status = await Permission.manageExternalStorage.status;
    if (status.isDenied) {
      return;
    }
    if (status.isGranted) {
      try {
        var uuid = const Uuid();
        String uid = uuid.v1();
        if(Platform.isAndroid){
          File('$path/${_headerController.text}$uid${_bodyController.text}.png')
              .writeAsBytes(
              buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        }
        else{
          File('${downloadsDir!.path}/${_headerController.text}$uid${_bodyController.text}.png')
              .writeAsBytes(
              buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Сохранено в загрузки')));
      } on Exception catch (e) {
        print(e);
      }
    }
  }
}


