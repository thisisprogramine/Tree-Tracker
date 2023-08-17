
import 'dart:io';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../model/TreeLocation.dart';

class FileService {
  FileService._();

  static void saveFile({required String filename, required Map<String, dynamic> json}) async{

    // Uint8List bytes = Uint8List.fromList(json.toString().codeUnits);
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // File file = File(
    //     "$dir/$filename.json");
    // await file.writeAsBytes(bytes);

    var excel = Excel.createExcel();
    var sheet = excel['Plants'];

    final location = PlantLocation.fromJson(json).locations;

    sheet.appendRow(['Latitude', 'Longitude']);

    for(int i = 0; i < (location?.length ?? 0); i++) {
      print("${location?[i].latitude} ${location?[i].longitude}");
      sheet.appendRow([location?[i].latitude, location?[i].longitude]);
    }


    Uint8List bytes = Uint8List.fromList(excel.save() ?? []);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
          "$dir/$filename.xlsx");
      await file.writeAsBytes(bytes);

    DocumentFileSavePlus.saveFile(bytes, "$filename.xlsx", '.xlsx');

    Share.shareXFiles([XFile(file.path)]);

  }

  // static void openFile(
  //     {required BuildContext context, required Document document}) async {
  //   final downloadedDocument = getItInstance<DownloadDocuments>();
  //
  //   final eitherDownload = await downloadedDocument(DownloadParams(
  //       documentId: document.id ?? '',
  //       name: document.filename ?? '',
  //       extension: document.filename
  //           ?.substring(document.filename?.lastIndexOf('.') ?? 0) ??
  //           '',
  //       type: document.type ?? ''));
  //
  //   eitherDownload.fold((error) {
  //     FlashHelper.showToastMessage(context, message: 'Failed to open');
  //   }, (response) async {
  //     Uint8List bytes = response.file;
  //     String dir;
  //     if (Platform.isAndroid) {
  //       dir = (await getExternalStorageDirectory())?.path ?? '';
  //     } else {
  //       dir = (await getApplicationDocumentsDirectory()).path;
  //     }
  //     File file = File("$dir/${response.name}");
  //     await file.writeAsBytes(bytes);
  //     OpenFilex.open(file.path);
  //   });
  // }

  // static void shareFile({required BuildContext context, required Document document}) async{
  //   final downloadedDocument = getItInstance<DownloadDocuments>();
  //
  //   final eitherDownload = await downloadedDocument(DownloadParams(documentId: document.id ?? '', name: document.filename ?? '', extension: document.filename?.substring(document.filename?.lastIndexOf('.') ?? 0) ?? '', type: document.type ?? ''));
  //
  //   eitherDownload.fold((error) {
  //     FlashHelper.showToastMessage(context, message: 'Failed to share');
  //   }, (response) async{
  //     Uint8List bytes = response.file;
  //     String dir = (await getApplicationDocumentsDirectory()).path;
  //     File file = File(
  //         "$dir/${response.name}");
  //     await file.writeAsBytes(bytes);
  //     Share.shareXFiles([XFile(file.path)]);
  //   });
  // }

}