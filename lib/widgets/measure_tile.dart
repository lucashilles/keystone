import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MeasureTile extends StatelessWidget {
  const MeasureTile({Key? key, required this.measureData}) : super(key: key);

  final Map<String, dynamic> measureData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: measureData['measure'],
      subtitle: measureData['date'],
    );
  }
}
