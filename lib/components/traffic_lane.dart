import 'package:flutter/material.dart';

class TrafficLaneWidget extends StatelessWidget {
  const TrafficLaneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 163.0, // Ajuste a altura conforme necessário
      // Cor de fundo da faixa de trânsito
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 3,
                width: screenWidth,
                color: Colors.white, // Cor da faixa contínua nas extremidades
              ),
              SizedBox(height: 0.18 * screenWidth), // Espaço entre as faixas
              DashedLine(
                color: Colors.amber,
                height: 2,
                width: screenWidth,
              ),
              SizedBox(height: 0.01 * screenWidth),
              DashedLine(
                color: Colors.amber,
                height: 2,
                width: screenWidth,
              ),
              SizedBox(height: 0.18 * screenWidth), // Espaço entre as faixas
              Container(
                height: 3,
                width: screenWidth,
                color: Colors.white, // Cor da faixa contínua nas extremidades
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  final Color color;
  final double height;
  final double width;

  const DashedLine({Key? key, required this.color, required this.height, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(color),
      child: SizedBox(
        height: height,
        width: width,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const double dashWidth = 60.0;
    const double dashSpace = 30.0;

    double startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
