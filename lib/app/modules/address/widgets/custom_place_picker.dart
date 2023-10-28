import 'dart:math';
import 'package:delivery_customer/app/modules/address/address_store.dart';
import 'package:delivery_customer/app/modules/address/widgets/places_auto_complete_overlay.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/floating_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/models/address_model.dart';
import '../../../shared/utilities.dart';
import 'address_edition.dart';

class CustomPlacePicker extends StatefulWidget {
  final Map data;

  const CustomPlacePicker({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<CustomPlacePicker> createState() => _CustomPlacePickerState();
}

class _CustomPlacePickerState extends State<CustomPlacePicker> {
  final AddressStore store = Modular.get();
  bool editing = false;
  late Address address;

  @override
  void initState() {
    store.mapController = null;
    editing = widget.data['editing'];
    address = widget.data["address"];
    super.initState();
  }

  showPlacesAutoComplete() {
    late OverlayEntry placesAutocomplete;
    placesAutocomplete = OverlayEntry(
      builder: (context) => PlacesAutoCompleteOverlay(
        onBack: () => placesAutocomplete.remove(),
        address: address,
      ),
    );
    Overlay.of(context)!.insert(placesAutocomplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: maxHeight(context),
                width: maxWidth(context),
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: store.cameraPosition,
                  onCameraMove: (_cameraPosition) =>
                      store.cameraPosition = _cameraPosition,
                  onCameraIdle: () => WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
                    address = await store.getAddressByLocation(context, address);
                  }),
                  onMapCreated: (_controller) async{
                    store.mapController = _controller;
                    if (editing) {
                      store.setLatLng(LatLng(
                        address.latitude!,
                        address.longitude!,
                      ));
                    } else {
                      Address? _address = await store.getLocation(context, address);
                      if(_address != null){
                        address = _address;
                      }
                    }
                  },
                  circles: {if (store.circle != null) store.circle!},
                ),
              ),
              Icon(Icons.location_searching, color: Colors.black),
              Positioned(
                right: wXD(10, context),
                bottom: wXD(20, context),
                child: Column(
                  children: [
                    FloatingCircleButton(
                      onTap: () async{
                        Address? _address = await store.getLocation(context, address);
                        if(_address != null){
                          address = address;
                        }
                      },
                      size: wXD(45, context),
                      child: Icon(
                        Icons.my_location_rounded,
                        size: wXD(30, context),
                        color: getColors(context).onSurface,
                      ),
                    ),
                    SizedBox(height: wXD(15, context)),
                    FloatingCircleButton(
                      onTap: () => showPlacesAutoComplete(),
                      size: wXD(45, context),
                      child: Icon(
                        Icons.search,
                        size: wXD(30, context),
                        color: getColors(context).onSurface,
                      ),
                    ),
                    SizedBox(height: wXD(15, context)),
                    Opacity(
                      opacity: 1,
                      child: FloatingCircleButton(
                        onTap: () {
                          if (!editing) {
                            if(address.main == null){
                              address.main = true;
                              address.withoutComplement = false;
                            }
                          }
                          
                          store.addresEditionOverlay = OverlayEntry(
                            builder: (context) => AddressEdition(
                              address: address,
                              onBack: (_address) {
                                store.addresEditionOverlay!.remove();
                                store.addresEditionOverlay = null;

                                if (_address != null) {
                                  Modular.to.pushNamed(
                                    "/address/place-picker",
                                    arguments: {
                                      "address": _address,
                                      "editing": editing,
                                    });
                                }
                              },
                              editing: editing,
                            ),
                          );
                          Overlay.of(context)!.insert(store.addresEditionOverlay!);
                          Modular.to.pop();
                        },
                        size: wXD(45, context),
                        child: Icon(
                          Icons.check,
                          size: wXD(30, context),
                          color: getColors(context).onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: wXD(10, context),
                left: wXD(10, context),
                child: IconButton(
                  onPressed: () => Modular.to.pop(),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: wXD(25, context),
                    color: Colors.grey[850],
                  ),
                ),
              ),
              Positioned(
                top: wXD(50, context),
                child: GestureDetector(
                  onTap: () => showPlacesAutoComplete(),
                  child: Container(
                    height: wXD(40, context),
                    width: wXD(350, context, ws: 1500, mediaWeb: true),
                    decoration: BoxDecoration(
                      color: getColors(context).surface,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 3),
                          color: getColors(context).shadow,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: wXD(10, context)),
                    child: Text(
                      address.formatedAddress ?? "Local no mapa",
                      textAlign: TextAlign.center,
                      style: textFamily(
                        context,
                        fontSize: 14,
                        color: getColors(context).onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxrxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
