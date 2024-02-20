import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {//Виджет для рисования шаблона демотиватора
  Color color;
  ui.Image? image;
  String header;
  String body;

  MyCustomPainter(
      {required this.color,
        required this.image,
        required this.header,
        required this.body});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    var path = Path();
    path.lineTo(size.width, 0); //горизонтальная линия сверху
    path.lineTo(size.width, size.height); //правая линия вниз
    path.moveTo(0, size.height); //двигаемся вниз правой линии
    path.lineTo(size.width, size.height); //нижняя линия
    path.moveTo(0, 0); //дивгаемся в левый верхний угол
    path.lineTo(0, size.height); //рисуем линию вниз
    path.moveTo(60, 250); //внутренняя картинка
    path.lineTo(60, 30); //рисуем левую линию вниз
    path.moveTo(320, 250); //внутренняя картинка
    path.lineTo(320, 30); //правая линия
    path.moveTo(60, 30); //внутренняя картинка
    path.lineTo(320, 30); //верхняя линия
    path.moveTo(60, 250); //внутренняя картинка
    path.lineTo(320, 250); //верхняя линия

    path.close();
    canvas.drawPath(path, paint);
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTRB(61, 31, 319, 249),
        image: image!,
        fit: BoxFit.contain);
    final ui.ParagraphBuilder paragraphBuilderHeader = ui.ParagraphBuilder(
      ui.ParagraphStyle(
          textDirection: ui.TextDirection.ltr,
          textAlign: ui.TextAlign.center,
          fontSize: 22),
    )..addText(header);
    final ui.Paragraph paragraphHeader = paragraphBuilderHeader.build()
      ..layout(ui.ParagraphConstraints(width: 320));
    canvas.drawParagraph(paragraphHeader, Offset(30, 255));

    final ui.ParagraphBuilder paragraphBuilderBody = ui.ParagraphBuilder(
      ui.ParagraphStyle(
          textDirection: ui.TextDirection.ltr,
          textAlign: ui.TextAlign.center,
          fontSize: 16),
    )..addText(body);
    final ui.Paragraph paragraphBody = paragraphBuilderBody.build()
      ..layout(ui.ParagraphConstraints(width: 320));
    canvas.drawParagraph(paragraphBody, Offset(30, 285));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}