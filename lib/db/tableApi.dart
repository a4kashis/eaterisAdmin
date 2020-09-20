import 'package:cloud_firestore/cloud_firestore.dart';

class TableApi {
  getTables() async {
    QuerySnapshot snaps =
        await Firestore.instance.collection('tables').getDocuments();

    return snaps.documents;
  }

  updateTable(String doc, bool value) {
    Firestore.instance.collection('tables').document(doc).updateData({
      'vacant': value,
  });
  }
}
