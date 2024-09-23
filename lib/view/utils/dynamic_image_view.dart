// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'dart:html' as html;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

Future<dynamic> dynamicImageView(
    {required String imageUrl,
    Widget? errorWidget,
    required BuildContext context}) {
  return showPlatformDialog(
    context: context,
    builder: (context) => GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 0.9,
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.none,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
                  errorWidget ?? const Icon(Icons.error),
            ),
          ),
          Positioned(
              right: 0,
              child: Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final http.Response responseData =
                              await http.get(Uri.parse(imageUrl));
                          var uint8list = responseData.bodyBytes;
                          html.AnchorElement(
                              href:
                                  "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(uint8list)}")
                            ..setAttribute("download",
                                "${DateTime.now().millisecondsSinceEpoch}.jpg")
                            ..click();
                        },
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )))
        ],
      ),
    ),
  );
}
