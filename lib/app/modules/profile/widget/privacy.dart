import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
                Text(
                  'Política de privacidade',
                  style: textFamily(
                    context,
                    color: getColors(context).primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  height: 800,
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('info').get(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return Center(child: LinearProgressIndicator());
                      }
                      QuerySnapshot infoQuery = snapshot.data!;
                      DocumentSnapshot infoDoc = infoQuery.docs[0];
                      print('infoDoc[privacy_policy] ${infoDoc['privacy_policy']}');
                      // String url = infoDoc['privacy_policy'];
                      String url = "https://firebasestorage.googleapis.com/v0/b/white-label-cca4f.appspot.com/o/info%2FPoli%CC%81tica%20de%20Privacidade.pdf?alt=media&token=c3ed6194-a5b8-49f4-bf6e-32f23c850b3e";
                      // String url = 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf';
                
                      return  SfPdfViewer.network(
                        url,
                        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details){
                          print('details: $details');
                          print('details: ${details.description}');
                          print('details: ${details.error}');
                        },
                        onDocumentLoaded: (PdfDocumentLoadedDetails details){
                          print('details: $details');
                          print('details: ${details.document}');
                        },                
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
          DefaultAppBar('Política de privacidade'),
        ],
      ),
    );
  }
}
