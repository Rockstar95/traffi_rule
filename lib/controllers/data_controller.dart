import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traffi_rule/controllers/firestore_controller.dart';

class DataController {
  Future<String> getNewDocId() async {
    String docId = "";

    docId = await FirestoreController.collectionReference(collectionName: "Temp").add({"name" : "dfghm"}).then((DocumentReference reference) async {
      await reference.delete();

      return reference.id;
    });

    print("DocId:$docId");
    return docId;
  }
}