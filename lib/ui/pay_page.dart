import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:qr_flutter/qr_flutter.dart';

const sum = 3000;

/// Форма оплаты
class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  PayPageState createState() => PayPageState();
}

/// Состояние формы оплаты
class PayPageState extends State<PayPage> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final org = bloc.activeOrg.valueOrNull;
    if (org == null) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(L10n.supportPayment),
        ),
        body: centerMessage(context, L10n.addOrg),
      );
    } else if (isEmpty(org.inn)) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(L10n.supportPayment),
        ),
        body: centerMessage(context, L10n.setInn),
      );
    } else {
      final startSupport = DateTime.now();
      final endSupport = startSupport.add(const Duration(days: 365));
      final purpose = 'Оплата техподдержки электронных табелей посещамости для ${org.name} ИНН ${org.inn} до ${dateToString(endSupport)}';
      final qrText = 'ST00012|Name=ИП Никитин Павел Александрович|PersonalAcc=40802810900002686224|BankName=АО «Тинькофф Банк»|BIC=044525974|CorrespAcc=30101810145250000974|PayeeINN=667341199471|Purpose=$purpose|TechCode=15|Sum=${sum}00';
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(L10n.supportPayment),
        ),
        body: Center(
          child: QrImage(
            data: qrText,
            version: QrVersions.auto,
            size: 300.0,
          )
        ),
      );
    }
  }
}
