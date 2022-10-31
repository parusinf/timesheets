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
  Widget build(BuildContext context) {
    final org = bloc.activeOrg.valueWrapper?.value;
    final startSupport = DateTime.now();
    final endSupport = startSupport.add(const Duration(days: 365));
    final description = 'Оплата техподдержки электронных табелей посещамости для ${org.name} ИНН ${org.inn} до ${dateToString(endSupport)}';

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(L10n.support),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
            data: '''<HTML>
<HEAD>
<style>
  .tinkoffPayRow {
    display:block;
    margin:5%;
    padding: 12px 12px;
    border: 12px solid var(--input-border);
    border-radius: 12px;
    width:90%;
    font-size: 3em;
    font-family: sans-serif;
  }
  input[type="submit"] {
    line-height: 60px;
  }
</style>
<link rel="stylesheet" href="./html/payForm/static/css/t-widget.css" type="text/css">
<script src="https://securepay.tinkoff.ru/html/payForm/js/tinkoff_v2.js"></script>
</HEAD>
<BODY>
<form name="TinkoffPayForm" onsubmit="pay(this); return false;">
	<input class="tinkoffPayRow" type="hidden" name="terminalkey" value="1666686688281" >
	<input class="tinkoffPayRow" type="hidden" name="frame" value="true">
	<input class="tinkoffPayRow" type="hidden" name="language" value="ru">
	<input class="tinkoffPayRow" type="text" readonly placeholder="Сумма годовой техподдержки" name="amount" value="3000" required>
	<input class="tinkoffPayRow" type="hidden" placeholder="Номер заказа" name="order">
	<input class="tinkoffPayRow" type="hidden" placeholder="Описание заказа" name="description" value="$description">
	<textarea class="tinkoffPayRow" rows="4" readonly>$description</textarea>
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
}
