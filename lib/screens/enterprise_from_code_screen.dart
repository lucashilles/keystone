import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:keystone/config.dart';
import 'package:keystone/utils/user_utils.dart';
import 'package:keystone/widgets/search_enterprise_dialog.dart';

class EnterpriseFromCodeScreen extends StatefulWidget {
  const EnterpriseFromCodeScreen({Key? key}) : super(key: key);
  static const String name = '/EnterpriseFromCode';

  @override
  _EnterpriseFromCodeScreenState createState() =>
      _EnterpriseFromCodeScreenState();
}

class _EnterpriseFromCodeScreenState extends State<EnterpriseFromCodeScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _searchAndAdd() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SearchEnterpriseDialog(
          enterpriseDoc: Config.getInstance()
              .firebaseFirestore
              .collection('enterprises')
              .doc(controller.text)
              .get(),
          onSave: () => UserUtils.addEnterprise(controller.text),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar por código'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              child: const Text(
                'Entre o código do empreendimento ou clique no botão para ler o QR.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          label: const Text('Código'),
                          border: const OutlineInputBorder().copyWith(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        var qrString = await FlutterBarcodeScanner.scanBarcode(
                            '#FFFFFF', 'Cancelar', false, ScanMode.QR);

                        if (qrString != '-1') {
                          controller.text = qrString.trim();
                        }
                      },
                      child: Icon(Icons.qr_code),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.length == 20) {
                    _searchAndAdd();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Código inválido!'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'ADICIONAR',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
