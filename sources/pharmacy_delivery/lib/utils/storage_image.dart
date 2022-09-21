import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:flutter/cupertino.dart';
import 'package:pharmacy_delivery/class/Medicine.dart';

import '../class/Stock.dart';
class StorageImage {

  final  storage = FirebaseStorage.instance;

  Future<String> downloadeURL(String folder,String imageName) async {
    Reference ref = storage.ref().child(folder+"/"+imageName);
    String downloadeURL = await ref.getDownloadURL();

    return downloadeURL;
  }

  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }


  /*
  Future<List<String>> downloadeURL_listMed(String folder,Future<List<Stock>> future) async {
    List<String> list =[];
    final listStock = await future;
    for(Stock s in listStock){
        String imageName = s.medicine!.medImg?? 'no_img.jpg';
        Reference ref = storage.ref().child(folder+"/"+imageName );
        String downloadeURL = await ref.getDownloadURL();
        list.add(downloadeURL);
    }
    return list ;
    // Future<List<String>> medImg_Future =  StorageImage().downloadeURL_listMed("medicine",snapShot_stock.data!);

  }
*/
}