// import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/profile/profile_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import '../../shared/widgets/load_circular_overlay.dart';
import 'package:mime/mime.dart';
part 'support_store.g.dart';

class SupportStore = _SupportStoreBase with _$SupportStore;

abstract class _SupportStoreBase with Store {
  final ProfileStore profileStore = Modular.get();
  _SupportStoreBase() {
    createSupport();
  }

  final MainStore mainStore = Modular.get();

  @observable
  TextEditingController textController = TextEditingController();
  @observable
  List<XFile> images = [];
  @observable
  List<Uint8List> bytesImages = [];
  // @observable
  // List<File> images = [];
  // @observable
  // List<String>? imagesName = [];
  // @observable
  // bool imagesBool = false;
  @observable
  int imagesPage = 0;
  @observable
  XFile? imageCam;
  @observable
  Uint8List? bytesImageCam;

  @action
  Future<void> clearNewSupportMessages() async {
    print('clearNewSupportMessages');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .update({
      "new_support_messages": 0,
    });
    // profileStore.setProfileEditFromDoc();
  }

  @action
  Future<void> createSupport() async {
    User? _user = FirebaseAuth.instance.currentUser;

    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "CUSTOMERS")
        .get();

    if (supportQuery.docs.isEmpty) {
      DocumentReference suporteRef =
          await FirebaseFirestore.instance.collection("supports").add({
        "user_id": _user.uid,
        "id": null,
        "created_at": FieldValue.serverTimestamp(),
        "updated_at": FieldValue.serverTimestamp(),
        "support_notification": 0,
        "last_update": "",
        "user_collection": "CUSTOMERS",
      });
      await suporteRef.update({"id": suporteRef.id});
    }
  }

  @action
  Future<void> sendSupportMessage() async {
    if (textController.text == "") return;
    User? _user = FirebaseAuth.instance.currentUser;
    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "CUSTOMERS")
        .get();

    print('supportQuery.docs.isNotEmpty: ${supportQuery.docs.isNotEmpty}');
    if (supportQuery.docs.isNotEmpty) {
      DocumentReference messageRef = await supportQuery.docs.first.reference.collection("messages").add({
        "id": null,
        "author": _user.uid,
        "text": textController.text,
        "created_at": FieldValue.serverTimestamp(),
        "file": null,
        "file_type": null,
      });

      await messageRef.update({
        "id": messageRef.id,
      });

      await supportQuery.docs.first.reference.update({
        "last_update": textController.text,
        "support_notification": FieldValue.increment(1),
      });
    }
    textController.clear();
  }

  @action
  void removeImage() {
    images.removeAt(imagesPage);
    if (imagesPage == images.length && imagesPage != 0) {
      imagesPage = images.length - 1;
    }
    print(imagesPage);
  }

  @action
  void cancelImages() {
    images.clear();
    bytesImages.clear();
    imagesPage = 0;
    imageCam = null;
    bytesImageCam = null;
    // imagesBool = false;
    // cameraImage = null;
  }

  @action
  Future sendImage(context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);

    final User? _user = FirebaseAuth.instance.currentUser;

    List<XFile> _images = imageCam == null ? images : [imageCam!];

    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "CUSTOMERS")
        .get();

    if (supportQuery.docs.isNotEmpty) {
      DocumentSnapshot supportDoc = supportQuery.docs.first;
      for (int i = 0; i < _images.length; i++) {
        XFile _imageFile = _images[i];
        Uint8List _imageBytes = imageCam == null ? bytesImages[i] : bytesImageCam!;

        Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('supports/${_user.uid}/images/${_imageFile.name}');

        UploadTask uploadTask = firebaseStorageRef.putData(_imageBytes);

        TaskSnapshot taskSnapshot = await uploadTask;

        String imageString = await taskSnapshot.ref.getDownloadURL();

        String? mimeType = lookupMimeType(_imageFile.path);

        DocumentReference messageRef =
            await supportDoc.reference.collection('messages').add({
          "created_at": FieldValue.serverTimestamp(),
          "author": _user.uid,
          "text": null,
          "id": null,
          "file": imageString,
          "file_type": mimeType,
        });

        await messageRef.update({
          "id": messageRef.id,
        });
      }

      Map<String, dynamic> chatUpd = {
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "[imagem]",
        "support_notification": FieldValue.increment(1 + _images.length),
      };

      await supportDoc.reference.update(chatUpd);
    }

    // imagesBool = false;
    // cameraImage = null;
    await Future.delayed(Duration(milliseconds: 500), () => images.clear());
    loadOverlay.remove();
    cancelImages();
  }
}
