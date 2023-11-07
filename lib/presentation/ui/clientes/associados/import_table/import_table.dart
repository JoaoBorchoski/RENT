import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/associados_repository.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class AssociadoImportTable extends StatefulWidget {
  const AssociadoImportTable({super.key});

  @override
  State<AssociadoImportTable> createState() => _AssociadoImportTableState();
}

class _AssociadoImportTableState extends State<AssociadoImportTable> {
  bool _dataIsLoaded = false;
  List<List<dynamic>> _associados = [[]];
  File? _csvFile;

  Future<void> _importAssociados() async {
    await Provider.of<AssociadosRepository>(context, listen: false).importAssociadosFile(_csvFile).then((value) {
      if (value != null) {
        if (value == 201) {
          Navigator.of(context).pushReplacementNamed('/associado');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao importar associados'),
            ),
          );
        }
      }
    });
  }

  List<Widget> _buildCells(List<dynamic> rowData) {
    return rowData.map((cellData) {
      return Container(
        alignment: Alignment.center,
        width: 120.0,
        height: 60.0,
        color: Colors.white,
        margin: EdgeInsets.all(4.0),
        child: Text(cellData.toString()),
      );
    }).toList();
  }

  List<Widget> _buildRows(int rowCount, int colCount) {
    List<Widget> rows = [];
    List<Widget> firstRowCells = [];

    // Add the labels for the first row
    for (int i = 0; i < colCount; i++) {
      firstRowCells.add(
        Container(
          alignment: Alignment.center,
          width: 120.0,
          height: 60.0,
          color: Colors.white,
          margin: EdgeInsets.all(4.0),
          child: Text(
            _getColumnLabel(i),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
    }

    // Add the first row with labels
    rows.add(
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: firstRowCells,
        ),
      ),
    );

    // Add remaining rows with cells
    for (int i = 0; i < rowCount; i++) {
      rows.add(
        Row(
          children: _buildCells(_associados[i]),
        ),
      );
    }

    return rows;
  }

  String _getColumnLabel(int index) {
    List<String> labels = [
      "Código Sócio",
      "Nome",
      "CPF",
      "Email",
      "Telefone",
      "Status",
      "CEP",
      "Endereço",
      "Número",
      "Bairro",
      "Cidade",
      "UF",
      "Complemento",
    ];
    if (index >= 0 && index < labels.length) {
      return labels[index];
    }
    return "Label Not Found";
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _associados = args['associados'] ?? [];
      _csvFile = args['csvFile'];
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        Navigator.of(context).pushReplacementNamed('/associado');
        return retorno;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: AppColors.background),
          title: Text('Importação de associados'),
          backgroundColor: AppColors.primary,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildRows(_associados.length, 13), // rows and 11 columns (including labels)
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _importAssociados,
          backgroundColor: AppColors.secondDegrade,
          icon: Icon(Icons.file_download_outlined),
          label: Text('Importar'),
        ),
      ),
    );
  }
}
