import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widgets/responsive.dart';
import 'widgets/score_date_picker.dart';
import 'dart:ui' as ui;

/// Valor da largura total: 375
double wXD(
  double size,
  BuildContext context, {
  double? ws,
  bool mediaWeb = false,
}) {
  if (Responsive.isDesktop(context)) {
    double _size = ws ?? size;
    if (mediaWeb) {
      return MediaQuery.of(context).size.width / 1920 * _size;
    } else {
      return _size;
    }
  }
  return MediaQuery.of(context).size.width / 375 * size;
}

/// Valor da largura total: 703
double hXD(double size, BuildContext context) {
  return MediaQuery.of(context).size.height / 703 * size;
}

double maxHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double maxWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double viewPaddingTop(context) => MediaQuery.of(context).viewPadding.top;

Brightness brightness =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window)
        .platformBrightness;

late ColorScheme colors;

ColorScheme getColors(context) => colors = Theme.of(context).colorScheme;

TextTheme getStyles(context) => Theme.of(context).textTheme;

TextStyle textFamily(
  context, {
  double? fontSize = 13,
  Color? color,
  FontWeight? fontWeight = FontWeight.w500,
  double? height,
  FontStyle? fontStyle,
}) {
  return GoogleFonts.montserrat(
    fontSize: fontSize,
    color: color ?? getColors(context).onBackground,
    fontWeight: fontWeight,
    height: height,
    fontStyle: fontStyle,
  );
}

SystemUiOverlayStyle getOverlayStyleFromColor(Color color) {
  Brightness brightness = ThemeData.estimateBrightnessForColor(color);
  return brightness == Brightness.dark
      ? SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: colors.surface,
          systemNavigationBarIconBrightness: Brightness.light,
        )
      : SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: colors.surface,
          systemNavigationBarIconBrightness: Brightness.dark);
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  if (value != null) {
    return newValue.format(value);
  } else {
    return '0,00';
  }
}

// Future<DateTime?> selectDate(BuildContext context,
//     {DateTime? initialDate}) async {
//   final DateTime? picked = await showDatePicker(
//     initialEntryMode: DatePickerEntryMode.calendarOnly,
//     initialDatePickerMode: DatePickerMode.year,
//     firstDate: DateTime(1900),
//     lastDate: DateTime(2025),
//     context: context,
//     initialDate: initialDate ?? DateTime.now(),
//     builder: (BuildContext context, Widget? child) {
//       return Theme(
//         data: ThemeData.light().copyWith(
//          getColors(context).primaryColor: const Color(0xFF41c3b3),
//           // ignore: deprecated_member_use
//           accentColor: const Color(0xFF21bcce),
//           colorScheme: ColorScheme.light(primary: const Color(0xFF41c3b3)),
//           buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
//         ),
//         child: child!,
//       );
//     },
//   );
//   return picked;
// }

OverlayEntry? dateOverlay;

void pickDate(context, {required void Function(DateTime?) onConfirm}) async {
  dateOverlay = OverlayEntry(
    maintainState: true,
    builder: (context) => ScoreDatePicker(
      onConfirm: (date) {
        onConfirm(date);
        dateOverlay!.remove();
        dateOverlay = null;
      },
      onCancel: () {
        dateOverlay!.remove();
        dateOverlay = null;
      },
    ),
  );
  Overlay.of(context)!.insert(dateOverlay!);
}

const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
Random _rnd = Random();

Future<XFile?> pickImage() async {
  bool permission =
      kIsWeb ? true : await Permission.storage.request().isGranted;
  if (permission) {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    } else {
      return pickedFile;
    }
  } else {
    return null;
  }
}

Future<Map?> pickMultiImage() async {
  bool permission =
      kIsWeb ? true : await Permission.storage.request().isGranted;
  if (permission) {
    ImagePicker picker = ImagePicker();
    List<XFile>? pickedListFile = await picker.pickMultiImage();

    if (pickedListFile == null) {
      return null;
    } else {
      List<Uint8List> bytesList = [];
      for (var i = 0; i < pickedListFile.length; i++) {
        XFile xFile = pickedListFile[i];
        Uint8List bytes = await xFile.readAsBytes();
        bytesList.add(bytes);
      }

      return {
        "xFile": pickedListFile,
        "bytes": bytesList,
      };
    }
  } else {
    return null;
  }
}

// Future<File?> pickCameraImage() async {
//   if (await Permission.storage.request().isGranted) {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//         source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
//     if (pickedFile != null) {
//       return File(pickedFile.path);
//     }
//   }
//   return null;
// }

// Future<List?> pickMultiImageWithName() async {
//   if (await Permission.storage.request().isGranted) {
//     final picker = ImagePicker();
//     final pickedListFile = await picker.pickMultiImage();
//     if (pickedListFile == null) {
//       return null;
//     } else {
//       List<File> _listFile = [];
//       List<String> _listFileName = [];
//       pickedListFile.forEach((xFile) {
//         _listFile.add(File(xFile.path));
//         _listFileName.add(xFile.name);
//       });
//       return [
//         _listFile,
//         _listFileName,
//       ];
//     }
//   } else {
//     return null;
//   }
// }

Future<Map<String, dynamic>?> pickCameraImage() async {
  if (await Permission.storage.request().isGranted) {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (pickedFile != null) {
      Uint8List bytes = await pickedFile.readAsBytes();
      return {
        "xFile": pickedFile,
        "bytes": bytes,
      };
    }
  }
  return null;
}

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

showToast(String msg, [Color? color]) =>
    // Fluttertoast.showToast(msg: msg, backgroundColor: color);
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );

MaskTextInputFormatter cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

// MaskTextInputFormatter rgMask =
//     MaskTextInputFormatter(mask: '###.###.##', filter: {"#": RegExp(r'[0-9]')});

MaskTextInputFormatter cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});

MaskTextInputFormatter cepMask =
    MaskTextInputFormatter(mask: '##.###-###', filter: {"#": RegExp(r'[0-9]')});

// MaskTextInputFormatter agencyMask =
//     MaskTextInputFormatter(mask: '####-#', filter: {"#": RegExp(r'[0-9]')});

MaskTextInputFormatter accountMask =
    MaskTextInputFormatter(mask: '#######-#', filter: {"#": RegExp(r'[0-9]')});

MaskTextInputFormatter operationMask =
    MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: '+## (##) #####-####', filter: {"#": RegExp(r'[0-9]')});

String getPortugueseStatus(String status) {
  if (status == "CANCELED") {
    return "Pedido cancelado";
  }
  // if (paid == false) {
  //   return "Aguardando pagamento";
  // } else {
  switch (status) {
    case "REQUESTED":
      return "Aguardando confirmação";
    case "PROCESSING":
      return "Em preparação";
    case "DELIVERY_REQUESTED":
      return "Procurando agente";
    case "DELIVERY_ACCEPTED":
      return "Aguardando agente";
    case "DELIVERY_REFUSED":
      return "Recusado pelo agente";
    case "DELIVERY_CANCELED":
      return "Cancelado pelo agente";
    case "TIMEOUT":
      return "Procurando agente";
    // return "Tempo esgotado";
    case "SENDED":
      return "A caminho";
    case "CANCELED":
      return "Cancelado";
    case "REFUSED":
      return "Recusado";
    case "CONCLUDED":
      return "Entregue";
    case "PAYMENT_FAILED":
      return "Falha no pagamento";
    default:
      return "Tradução não estabelecida: $status";
  }
  // }
}

Future<dynamic> cloudFunction({
  required String function,
  Map<String, dynamic> object = const {},
}) async {
  print('cloudFunction: $function');
  // Descomente a linha abaixo para usar o emulador
  // FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(function);
  try {
    // print("object: $object");
    HttpsCallableResult result = await callable.call(object);
    return result.data;
  } catch (e) {
    print("Error on function: $e");
    return e;
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
  BuildContext context,
  String assetName, {
  double height = 50,
  double width = 40,
}) async {
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  //Draws string representation of svg to DrawableRoot
  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "");
  ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
  ui.Image image = await picture.toImage(width.truncate(), height.truncate());
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

Future<File> getFile(String fileName) async {
  Directory dir = await getApplicationDocumentsDirectory();
  return File("${dir.path}/$fileName");
}
