
import 'dart:developer';

import 'package:flutter/material.dart';

//* Packages
import 'package:hexcolor/hexcolor.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class TableExample extends StatefulWidget {
  const TableExample({super.key});

  @override
  State<TableExample> createState() => _TableExampleState();
}

class _TableExampleState extends State<TableExample> {
  
  final datas = [
    ['Team', 'Working Hours/W'],
    ['PR AND MARKETING', 40],
    ['HR', 38],
    ['PR AND MARKETING', 48],
    ['DEVELOPERS', 35],
    ['PR AND MARKETING', 42],
    ['HR', 40],
  ];

  @override
  void initState() {
    _verticalController = ScrollController();
    _horizontalController = ScrollController();
    super.initState();
  }

  late final ScrollController _verticalController;
  late final ScrollController _horizontalController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: HexColor('F5F5F5'),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: size.height * 0.6,
            width: size.width * 0.9,
            child: Scrollbar(
              controller: _horizontalController,
              interactive: true,
              thumbVisibility: true,
              trackVisibility: true,
              child: Scrollbar(
                controller: _verticalController,
                interactive: true,
                thumbVisibility: true,
                trackVisibility: true,
                child: TableView.builder(
                  verticalDetails: ScrollableDetails.vertical(controller: _verticalController),
                  horizontalDetails: ScrollableDetails.horizontal(controller: _horizontalController),
                  cellBuilder: (context, vicinity) => _buildCell(context, vicinity),
                  columnCount: datas.first.length,
                  columnBuilder: (index) => _buildColumnSpan(index, size: size),
                  rowCount: datas.length,
                  rowBuilder: (index) => _buildRowSpan(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, TableVicinity vicinity) {
    Color? color;
    if (vicinity.row != 0 && vicinity.column == 1) {
      final data = datas[vicinity.row][vicinity.column] as int;
      color = data == 40
          ? HexColor('A8D08D')
          : data < 40
              ? HexColor('F4B083')
              : HexColor('FFC7CE');
    }
    return ColoredBox(
      color: color ?? Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${datas[vicinity.row][vicinity.column]}',
            style: TextStyle(
              fontSize: vicinity.row == 0 ? 16 : 14,
              fontWeight: vicinity.row == 0 ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
    );
  }

  TableSpan _buildColumnSpan(int index, {required Size size}) {
    const TableSpanDecoration decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(width: 0, color: Colors.transparent),
      ),
    );
    return TableSpan(
      foregroundDecoration: decoration,
      extent: FixedTableSpanExtent(size.width * 0.5),
    );
  }

  TableSpan _buildRowSpan(int index) {
    final color = index == 0
        ? Colors.transparent
        : index % 2 == 0
            ? Colors.white
            : HexColor('FFF3EA');
    log('color : $color');
    TableSpanDecoration decoration = TableSpanDecoration(
      color: color,
      border: const TableSpanBorder(
        trailing: BorderSide(width: 0, color: Colors.transparent),
      ),
    );
    return TableSpan(
      backgroundDecoration: decoration,
      extent: const FractionalTableSpanExtent(0.15),
    );
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }
}
