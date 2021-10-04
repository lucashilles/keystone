import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/widgets/add_measure_dialog.dart';
import 'package:keystone/widgets/enterprise_information.dart';
import 'package:keystone/widgets/enterprise_measurements.dart';

class EnterpriseScreen extends StatefulWidget {
  const EnterpriseScreen({Key? key}) : super(key: key);
  static const String name = '/EnterpriseDetail';

  @override
  _EnterpriseScreenState createState() => _EnterpriseScreenState();
}

class _EnterpriseScreenState extends State<EnterpriseScreen>
    with TickerProviderStateMixin {
  _EnterpriseScreenState();

  EnterpriseModel? enterprise;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    setState(() {});
  }

  void _addMeasureDialog() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddMeasureDialog(enterpriseId: enterprise!.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    enterprise = (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['enterprise'] as EnterpriseModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('${enterprise?.clientName}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'Medições',
            ),
            Tab(
              text: 'Informações',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EnterpriseMeasurements(enterprise: enterprise!),
          EnterpriseInformation(enterprise: enterprise!),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _tabController.index == 0,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _addMeasureDialog,
        ),
      ),
    );
  }
}
