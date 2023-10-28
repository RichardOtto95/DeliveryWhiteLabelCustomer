import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/models/address_model.dart';
import '../../../shared/utilities.dart';
import '../address_store.dart';

class PlacesAutoCompleteOverlay extends StatefulWidget {
  final void Function() onBack;
  final Address address;

  const PlacesAutoCompleteOverlay({
    Key? key,
    required this.onBack,
    required this.address,
  }) : super(key: key);

  @override
  State<PlacesAutoCompleteOverlay> createState() =>
      _PlacesAutoCompleteOverlayState();
}

class _PlacesAutoCompleteOverlayState extends State<PlacesAutoCompleteOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final AddressStore store = Modular.get();

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    animateTo(1);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
          Duration(milliseconds: 400), () => focusNode.requestFocus());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    focusNode.dispose();
  }

  Future<void> animateTo(double val) => _controller.animateTo(val,
      curve: Curves.easeOutQuad, duration: Duration(milliseconds: 400));

  String searchText = "";

  List places = [];

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: maxHeight(context),
      width: maxWidth(context),
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = _controller.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: value * 2 + 0.001,
                    sigmaY: value * 2 + 0.001,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await animateTo(0);
                      widget.onBack();
                    },
                    child: Container(
                      height: maxHeight(context),
                      width: maxWidth(context),
                      color: getColors(context).shadow.withOpacity(value * .3),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: (value * .9) + .1,
                    child: Container(
                      color: getColors(context).surface,
                      width: wXD(300, context),
                      child: StatefulBuilder(
                        builder: (context, stateSet) {
                          // print("searchText: $searchText");
                          // print("places: $places");
                          // print("loading: $loading");
                          return Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: wXD(30, context),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: wXD(12, context),
                                    vertical: wXD(7, context),
                                  ),
                                  decoration: BoxDecoration(
                                    color: getColors(context).surface,
                                    border: Border(
                                      bottom: BorderSide(
                                          color: getColors(context).onSurface),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: TextField(
                                    focusNode: focusNode,
                                    autofocus: true,
                                    onChanged: (txt) async {
                                      searchText = txt;
                                      if (txt.isEmpty) {
                                        stateSet(() {
                                          loading = false;
                                          places.clear();
                                        });
                                      } else {
                                        stateSet(() {
                                          loading = true;
                                        });
                                        Map response = await store.searchPlaces(
                                            context, searchText);
                                        stateSet(() {
                                          places = response["results"];
                                          loading = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Pesquisar endereço",
                                    ),
                                  ),
                                ),
                                if (loading) LinearProgressIndicator(),
                                if (searchText.isEmpty)
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Powered by Google",
                                      style: textFamily(
                                        context,
                                        color: getColors(context).onSurface,
                                      ),
                                    ),
                                  ),
                                if (!loading &&
                                    places.isEmpty &&
                                    searchText.isNotEmpty)
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Nenhum endereço encontrado",
                                      style: textFamily(
                                        context,
                                        color: getColors(context).onSurface,
                                      ),
                                    ),
                                  ),
                                if (!loading &&
                                    places.isNotEmpty &&
                                    searchText.isNotEmpty)
                                  ...places.map(
                                    (addressJ) => InkWell(
                                      onTap: () async {
                                        print("addressJ: $addressJ");

                                        await store.setAddressByLatLng(
                                          context,
                                          LatLng(
                                            addressJ["geometry"]["location"]
                                                ["lat"],
                                            addressJ["geometry"]["location"]
                                                ["lng"],
                                          ),
                                          widget.address,
                                        );
                                        await animateTo(0);
                                        widget.onBack();
                                        // widget.onSelect();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: wXD(40, context),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                // vertical: wXD(5, context),
                                                horizontal: wXD(10, context),
                                              ),
                                              child: Icon(
                                                Icons.location_on,
                                                size: wXD(16, context),
                                                color: getColors(context)
                                                    .onSurface,
                                              ),
                                            ),
                                            SizedBox(
                                              width: wXD(260, context),
                                              child: Text(
                                                addressJ["formatted_address"],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: textFamily(
                                                  context,
                                                  color: getColors(context)
                                                      .onSurface,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
