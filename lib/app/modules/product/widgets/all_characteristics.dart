import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

import 'characteristic.dart';

class AllCharacteristics extends StatelessWidget {
  const AllCharacteristics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: wXD(24, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
                Characteristic(title: 'Tamanho da tela', data: '6.5'),
                Characteristic(title: 'Memória interna', data: '64 GB'),
                Characteristic(
                    title: 'Câmera frontalfrontalfrontalfrontal ou principal',
                    data: '8 Mpx'),
                Characteristic(
                    title: 'Câmera traseira principal', data: '48 Mpx'),
                Characteristic(title: 'Desbloqueio', data: 'Impressão digital'),
                Characteristic(title: 'Tamanho da tela', data: '6.5'),
                Characteristic(title: 'Memória interna', data: '64 GB'),
                Characteristic(
                    title: 'Câmera frontal ou principal', data: '8 Mpx'),
                Characteristic(
                    title: 'Câmera traseira principal', data: '48 Mpx'),
                Characteristic(title: 'Desbloqueio', data: 'Impressão digital'),
              ],
            ),
          ),
          DefaultAppBar('Caracteristicas'),
        ],
      ),
    );
  }
}
