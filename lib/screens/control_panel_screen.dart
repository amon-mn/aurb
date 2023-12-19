import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ControlPanelPage extends StatelessWidget {
  final List<StatusData> data = [
    StatusData('Concluídas', 314),
    StatusData('Em Andamento', 122),
    StatusData('Não Iniciado', 258),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                customIcon: Icons.arrow_back,
                customOnPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 40), // Espaço entre o header e o conteúdo
              Padding(
                padding: EdgeInsets.only(left: 35.0),
                child: Text(
                  'Gráfico de Status das Ocorrências',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 350.0,
                  child: _buildBarChart(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    List<charts.Series<StatusData, String>> series = [
      charts.Series(
        id: 'Solicitações',
        data: data,
        domainFn: (StatusData status, _) => status.status,
        measureFn: (StatusData status, _) => status.quantity,
        colorFn: (StatusData status, _) => charts.ColorUtil.fromDartColor(
          _getColorForStatus(status.status),
        ),
      ),
    ];

    return charts.BarChart(
      series,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.NoneRenderSpec(),
      ),
    );
  }

  Color _getColorForStatus(String status) {
    if (status == 'Concluídas') {
      return Colors.green;
    } else if (status == 'Em Andamento') {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }
}

class StatusData {
  final String status;
  final int quantity;

  StatusData(this.status, this.quantity);
}
