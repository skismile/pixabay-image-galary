import 'package:flutter/material.dart';
import 'package:gallery/view/utils/dynamic_image_view.dart';

class ImageCard extends StatelessWidget {
  final String url;
  final String totalLike;
  final String totalView;
  const ImageCard(
      {Key? key,
      required this.url,
      required this.totalView,
      required this.totalLike})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        dynamicImageView(imageUrl: url, context: context);
      },
      child: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(fit: BoxFit.cover, image: NetworkImage(url))),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                color: Colors.black.withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.thumb_up,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          totalLike,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.visibility, color: Colors.white),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          totalView,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
