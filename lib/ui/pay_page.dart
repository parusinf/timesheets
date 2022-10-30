import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';

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
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(L10n.support),
    ),
    body: InAppWebView(
      initialData: InAppWebViewInitialData(
        data: '''<HTML>
<HEAD>
<style>.tinkoffPayRow{display:block;margin:1%;width:160px;}</style>
<link rel="stylesheet" href="./html/payForm/static/css/t-widget.css" type="text/css">
<script src="https://rest-api-test.tinkoff.ru/html/payForm/js/tinkoff.js"></script>
</HEAD>
<BODY>
<form name="TinkoffPayForm" onsubmit="pay(this); return false;">
	<input class="tinkoffPayRow" type="hidden" name="terminalkey" value="1666686688281DEMO" >
	<input class="tinkoffPayRow" type="hidden" name="frame" value="true">
	<input class="tinkoffPayRow" type="hidden" name="language" value="ru">
	<input class="tinkoffPayRow" type="text" placeholder="Сумма за год" name="amount" value="3000" required>
	<input class="tinkoffPayRow" type="hidden" placeholder="Номер заказа" name="order">
	<input class="tinkoffPayRow" type="hidden" placeholder="Описание заказа" name="description">
	<input class="tinkoffPayRow" type="hidden" placeholder="ФИО плательщика" name="name">
	<input class="tinkoffPayRow" type="hidden" placeholder="E-mail" name="email">
	<input class="tinkoffPayRow" type="hidden" placeholder="Контактный телефон" name="phone">
	<input class="tinkoffPayRow" type="submit" value="Оплатить">
</form>
</BODY>
</HTML>
'''
      ),
    ),
  );
}
