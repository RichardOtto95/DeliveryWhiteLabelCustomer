import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressSetup extends StatefulWidget {
  final bool homeRoot;

  const AddressSetup({Key? key, this.homeRoot = false}) : super(key: key);

  @override
  _AddressSetupState createState() => _AddressSetupState();
}

class _AddressSetupState extends State<AddressSetup> {
  @override
  Widget build(BuildContext context) {
    print('AddressSetup ${FirebaseAuth.instance.currentUser!.emailVerified}');
    return Scaffold(
      backgroundColor: white,
      body:
          //  Container(
          //   height: maxWidth(context),
          //   width: maxWidth(context),
          //   child:
          Column(
        children: [
          Container(
            width: maxWidth(context),
            padding: EdgeInsets.only(
                top: wXD(50, context), bottom: wXD(32, context)),
            alignment: Alignment.center,
            child: Text(
              'Qual é o seu endereço de entrega?',
              style: GoogleFonts.montserrat(
                fontStyle: FontStyle.italic,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SearchAddress(
            onTap: () async {},
          ),
          GestureDetector(
            onTap: () => Modular.to
                .pushNamed('/address/address-map', arguments: widget.homeRoot),
            child: Container(
              width: maxWidth(context),
              margin: EdgeInsets.symmetric(horizontal: wXD(27, context)),
              padding: EdgeInsets.only(
                bottom: wXD(24, context),
                top: wXD(34, context),
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xff241332).withOpacity(.3)))),
              child: Row(
                children: [
                  Icon(
                    Icons.my_location,
                    size: wXD(20, context),
                    color: getColors(context).primary,
                  ),
                  SizedBox(width: wXD(14, context)),
                  Text(
                    'Usar minha localização',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff555869),
                    ),
                  ),
                ],
              ),
            ),
          ),
          RecentAddress(),
        ],
      ),
      // ),
    );
  }
}

class SearchAddress extends StatelessWidget {
  final void Function() onTap;
  const SearchAddress({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(52, context),
      width: wXD(322, context),
      padding: EdgeInsets.symmetric(horizontal: wXD(16, context)),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: Color(0xffE8E8E8)),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            offset: Offset(0, wXD(12, context)),
            blurRadius: wXD(12, context),
          )
        ],
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            size: wXD(25, context),
            color: getColors(context).primary,
          ),
          SizedBox(width: wXD(9, context)),
          Text(
            'Inserir endereço com número',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: getColors(context).onBackground.withOpacity(.55),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      margin: EdgeInsets.symmetric(horizontal: wXD(27, context)),
      padding: EdgeInsets.only(
        bottom: wXD(7, context),
        top: wXD(17, context),
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color(0xff241332).withOpacity(.3)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.access_time_filled_sharp,
            size: wXD(20, context),
            color: Color(0xff817889).withOpacity(.4),
          ),
          SizedBox(width: wXD(14, context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: maxWidth(context) - wXD(90, context),
                child: Text(
                  'SHVP Rua 123 Ch 321 casa 123 Condomínio Hawai',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff817889).withOpacity(.5),
                  ),
                ),
              ),
              Container(
                width: wXD(250, context),
              )
            ],
          ),
        ],
      ),
    );
  }
}
