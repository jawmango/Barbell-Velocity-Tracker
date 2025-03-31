import 'dart:io';

import 'package:flutter/material.dart';

class GraphPage extends StatelessWidget {
  final File summaryFile;
  const GraphPage({super.key, required this.summaryFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: FileImage(summaryFile))),
        ),
      ),
    );
  }
}
