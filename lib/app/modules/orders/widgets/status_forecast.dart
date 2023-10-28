import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class StatusForecast extends StatelessWidget {
  final String status;
  final String? deliveryForecast;
  final String deliveryForecastLabel;
  // final bool paid;
  const StatusForecast({
    Key? key,
    required this.deliveryForecastLabel,
    required this.status,
    required this.deliveryForecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: wXD(56, context),
        width: wXD(343, context),
        padding: EdgeInsets.symmetric(
            vertical: wXD(13, context), horizontal: wXD(16, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: getColors(context).surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: getColors(context).shadow,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status atual',
                  style: textFamily(
                    context,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: getColors(context).primary,
                  ),
                ),
                Text(
                  // getPortugueseStatus(status, paid),
                  getPortugueseStatus(status),
                  style: textFamily(
                    context,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: getColors(context).onSurface,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  deliveryForecastLabel,
                  style: textFamily(
                    context,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: getColors(context).primary,
                  ),
                ),
                deliveryForecast == null
                    ? Container(
                        height: wXD(12, context),
                        width: wXD(80, context),
                        child: LinearProgressIndicator(
                          color: getColors(context).onSurface.withOpacity(.4),
                          backgroundColor:
                              getColors(context).onSurface.withOpacity(.4),
                          valueColor: AlwaysStoppedAnimation(
                              getColors(context).onSurface),
                        ),
                      )
                    : Text(
                        deliveryForecast!,
                        style: textFamily(
                          context,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: getColors(context).onSurface,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
