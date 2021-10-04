import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrReference extends StatelessWidget {
  const QrReference({Key? key, required this.reference, required this.password})
      : super(key: key);

  final String reference;
  final String password;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: reference));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Referência copiada!')));
          },
          child: Column(
            children: [
              QrImage(
                data: reference,
                version: QrVersions.auto,
                size: 200.0,
              ),
              Text(
                reference,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 16),
              ),
              Text(
                'Senha: $password',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
