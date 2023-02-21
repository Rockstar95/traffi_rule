import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traffi_rule/configs/typedefs.dart';
import 'package:traffi_rule/controllers/firestore_controller.dart';
import 'package:traffi_rule/providers/user_provider.dart';
import 'package:traffi_rule/utils/parsing_helper.dart';

class DataController {
  Future<String> getBackgroundImageUrl({required UserProvider userProvider}) async {
    String backgroundImage = "";

    MyFirestoreDocumentSnapshot snapshot = await FirestoreController.documentReference(
      collectionName: "admin",
      documentId: "property",
    ).get();

    if(snapshot.data()?.isNotEmpty ?? false) {
      Map<String, dynamic> data = snapshot.data()!;
      backgroundImage = ParsingHelper.parseStringMethod(data['backgroundImage']);

      userProvider.backgroundImageUrl = backgroundImage;
    }

    return backgroundImage;
  }

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