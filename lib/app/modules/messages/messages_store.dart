import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:mobx/mobx.dart';
import '../../core/models/agent_model.dart';
import '../../core/models/customer_model.dart';
import '../../core/models/message_model.dart';
import '../../core/models/seller_model.dart';
import '../profile/profile_store.dart';

part 'messages_store.g.dart';

class MessagesStore = _MessagesStoreBase with _$MessagesStore;

abstract class _MessagesStoreBase with Store {
  final ProfileStore profileStore = Modular.get();
  @observable
  String chatId = "";
  @observable
  String receiverName = "";
  @observable
  String recColl = "";
  @observable
  String text = "";
  @observable
  Customer? customer;
  @observable
  Seller? seller;
  @observable
  Agent? agent;
  @observable
  TextEditingController? textChatController;
  @observable
  List<String> messageIds = [];
  // @observable
  // File? cameraImage;
  // @observable
  // ObservableList<File> images = <File>[].asObservable();
  // @observable
  // bool imagesBool = false;
  @observable
  int imagesPage = 0;
  @observable
  List<DocumentSnapshot<Map<String, dynamic>>>? searchedChats;
  @observable
  List<SearchMessage>? searchedMessages;
  @observable
  ObservableList<Message> messages = <Message>[].asObservable();
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? messagesSubscription;
  @observable
  Uint8List? bytesImageCam;
  @observable
  XFile? imageCam;
  @observable
  List<XFile> images = [];
  @observable
  List<Uint8List> bytesImages = [];

  bool getShowUserData(int i) => messages[i].author != messages[i - 1].author;

  bool getIsAuthor(int i) => messages[i].userType == "CUSTOMER";

  @action
  Future<void> clearNewMessages() async {
    print('clearNewMessagess');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .update({
      "new_messages": 0,
    });
  }

  @action
  searchMessages(
    String _text,
    QuerySnapshot<Map<String, dynamic>> chatQue,
  ) async {
    print("searchMessages: $searchMessages");
    if (_text == "") {
      searchedChats = null;
      searchedMessages = null;
      return;
    }

    List<DocumentSnapshot<Map<String, dynamic>>> _chats = [];
    List<SearchMessage> _messages = [];

    for (DocumentSnapshot<Map<String, dynamic>> chatDoc in chatQue.docs) {
      DocumentSnapshot userDoc;
      String receiverId = "";
      String receiverCollection = "";
      if (chatDoc["seller_id"] != null) {
        final selDoc = await FirebaseFirestore.instance
            .collection("sellers")
            .doc(chatDoc["seller_id"])
            .get();
        userDoc = selDoc;
        receiverCollection = "sellers";
        receiverId = chatDoc["seller_id"];
        if (selDoc["username"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _chats.add(chatDoc);
        }
      } else {
        final emiDoc = await FirebaseFirestore.instance
            .collection("agents")
            .doc(chatDoc["agent_id"])
            .get();
        userDoc = emiDoc;
        receiverCollection = "agents";
        receiverId = chatDoc["agent_id"];
        if (emiDoc["username"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _chats.add(emiDoc);
        }
      }

      final mesQue = await chatDoc.reference.collection("messages").get();

      for (DocumentSnapshot mesDoc in mesQue.docs) {
        if (mesDoc["text"]
            .toString()
            .toLowerCase()
            .contains(_text.toLowerCase())) {
          _messages.add(
            SearchMessage(
              Message.fromDoc(mesDoc),
              mesDoc["user_type"] == "CUSTOMER" ? "Você" : userDoc["username"],
              receiverId,
              receiverCollection,
            ),
          );
        }
      }
    }

    searchedChats = _chats;
    searchedMessages = _messages;
  }

  @action
  Future<String> loadChatData(
    String receiverId,
    String receiverCollection,
  ) async {
    User user = FirebaseAuth.instance.currentUser!;
    recColl = receiverCollection;
    QuerySnapshot chatQue;

    DocumentSnapshot recDoc = await FirebaseFirestore.instance
      .collection(receiverCollection)
      .doc(receiverId)
      .get();

    if (receiverCollection == "sellers") {
      chatQue = await FirebaseFirestore.instance
          .collection("chats")
          .where("customer_id", isEqualTo: user.uid)
          .where("seller_id", isEqualTo: receiverId)
          .get();
      seller = Seller.fromDoc(recDoc);
    } else {
      chatQue = await FirebaseFirestore.instance
          .collection("chats")
          .where("customer_id", isEqualTo: user.uid)
          .where("agent_id", isEqualTo: receiverId)
          .get();
      agent = Agent.fromDoc(recDoc);
    }

    final cusDoc = await FirebaseFirestore.instance
        .collection("customers")
        .doc(user.uid)
        .get();

    customer = Customer.fromDoc(cusDoc);

    if (chatQue.docs.isEmpty) {
      await createChat(cusDoc, recDoc);
      return recDoc["username"];
    }

    final chatDoc = chatQue.docs.first;

    chatId = chatDoc.id;

    print("customer_notifications: ${chatDoc.get("customer_notifications")}");

    int newMessages = cusDoc.get("new_messages");

    if (newMessages <= chatDoc.get("customer_notifications")) {
      newMessages = 0;
    }

    cusDoc.reference
        .update({"new_messages": FieldValue.increment(-newMessages)});

    final chatStream = chatDoc.reference
        .collection("messages")
        .orderBy("created_at")
        .snapshots();

    messagesSubscription = chatStream.listen((event) async {
      event.docChanges.forEach((element) {
        if (!messageIds.contains(element.doc.id) &&
            element.doc["created_at"] != null) {
          messages.insert(messages.length, Message.fromDoc(element.doc));
          messageIds.add(element.doc.id);
        }
      });
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatId)
          .update({"customer_notifications": 0});
    });
    return recDoc["username"];
  }

  @action
  Future<void> createChat(
    DocumentSnapshot cusDoc,
    DocumentSnapshot recDoc,
  ) async {
    User user = FirebaseAuth.instance.currentUser!;
    final chatRef = FirebaseFirestore.instance.collection("chats").doc();

    if (recColl == "sellers") {
      await chatRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "customer_id": user.uid,
        "seller_id": recDoc.id,
        "agent_id": null,
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "",
        "id": chatRef.id,
        "seller_notifications": 0,
        "customer_notifications": 0,
        "agent_notifications": 0,
      });
    } else {
      await chatRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "customer_id": user.uid,
        "seller_id": null,
        "agent_id": recDoc.id,
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "",
        "id": chatRef.id,
        "seller_notifications": 0,
        "customer_notifications": 0,
        "agent_notifications": 0,
      });
    }

    await chatRef.update({"id": chatRef.id});

    chatId = chatRef.id;

    Stream<QuerySnapshot<Map<String, dynamic>>> messQue =
        chatRef.collection("messages").orderBy("created_at").snapshots();

    messagesSubscription = messQue.listen((event) async {
      event.docChanges.forEach((element) {
        if (!messageIds.contains(element.doc.id) &&
            element.doc["created_at"] != null) {
          messages.insert(messages.length, Message.fromDoc(element.doc));
          messageIds.add(element.doc.id);
        }
      });
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatId)
          .update({"customer_notifications": 0});
    });
  }

  @action
  Future sendMessage() async {
    User user = FirebaseAuth.instance.currentUser!;
    if (text == "") return;
    textChatController!.clear();
    String _text = text;
    text = "";

    DocumentSnapshot<Map<String, dynamic>> chatDoc =
        await FirebaseFirestore.instance.collection("chats").doc(chatId).get();

    final tstRef = chatDoc.reference.collection("messages").doc();

    await tstRef.set({
      "created_at": FieldValue.serverTimestamp(),
      "author": user.uid,
      "text": _text,
      "id": tstRef.id,
      "file": null,
      "file_type": null,
      "user_type": "CUSTOMER",
    });

    Map<String, dynamic> chatUpd = {
      "updated_at": FieldValue.serverTimestamp(),
      "last_update": _text,
    };

    if (recColl == "sellers") {
      chatUpd["seller_notifications"] = chatDoc["seller_notifications"] + 1;
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(chatDoc["seller_id"])
          .update({
        "new_messages": FieldValue.increment(1),
      });
    } else {
      chatUpd["agent_notifications"] = chatDoc["agent_notifications"] + 1;
      FirebaseFirestore.instance
          .collection("agents")
          .doc(chatDoc["agent_id"])
          .update({
        "new_messages": FieldValue.increment(1),
      });
    }

    await chatDoc.reference.update(chatUpd);
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
  }

  @action
  Future sendImage(context) async {
    User user = FirebaseAuth.instance.currentUser!;
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);

    List<XFile> _images = imageCam == null ? images : [imageCam!];
    DocumentSnapshot<Map<String, dynamic>> chatDoc = await FirebaseFirestore.instance.collection("chats").doc(chatId).get();

    for (int i = 0; i < _images.length; i++) {
      final msgRef = chatDoc.reference.collection("messages").doc();
      XFile _imageFile = _images[i];
      Uint8List _imageBytes = imageCam == null ? bytesImages[i] : bytesImageCam!;

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('sellers/${user.uid}/chats/${chatDoc.id}/${msgRef.id}');
      UploadTask uploadTask = firebaseStorageRef.putData(_imageBytes);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageString = await taskSnapshot.ref.getDownloadURL();

      String? mimeType = lookupMimeType(_imageFile.path);

      await msgRef.set({
        "created_at": FieldValue.serverTimestamp(),
        "author": user.uid,
        "text": null,
        "id": msgRef.id,
        "file": imageString,
        "file_type": mimeType,
        "user_type": "CUSTOMER",
      });
    }

    Map<String, dynamic> chatUpd = {
      "updated_at": FieldValue.serverTimestamp(),
      "last_update": "[imagem]",
    };

    if (recColl == "sellers") {
      chatUpd["seller_notifications"] =
          chatDoc["seller_notifications"] + _images.length;
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(chatDoc["seller_id"])
          .update({
        "new_messages": FieldValue.increment(1 + _images.length),
      });
    } else {
      chatUpd["agent_notifications"] =
          chatDoc["agent_notifications"] + _images.length;
      FirebaseFirestore.instance
          .collection("agents")
          .doc(chatDoc["agent_id"])
          .update({
        "new_messages": FieldValue.increment(1 + _images.length),
      });
    }

    await chatDoc.reference.update(chatUpd);

    await Future.delayed(Duration(milliseconds: 500), () => images.clear());
    loadOverlay.remove();
    cancelImages();
  }

  @action
  void disposeChat() {
    print("dispose do chat");
    textChatController!.dispose();
    if (messagesSubscription != null) messagesSubscription!.cancel();
    messagesSubscription = null;
    seller = null;
    agent = null;
    messages.clear();
    messageIds.clear();
    cancelImages();
  }

  void disposeMessages() {
    searchedChats = null;
    searchedMessages = null;
  }
}
