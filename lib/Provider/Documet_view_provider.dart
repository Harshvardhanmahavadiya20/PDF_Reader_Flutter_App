

import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumetViewProvider extends ChangeNotifier {
  bool searched = false;
  var selectedFile = "";
  var check;

  TextEditingController searchTextController = TextEditingController();
  PdfViewerController pdfViewerController = PdfViewerController();
  final formKey = GlobalKey<FormState>();
  shareFile() async {

  }
}
