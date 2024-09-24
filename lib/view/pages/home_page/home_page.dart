import 'package:flutter/material.dart';
import 'package:gallery/controller/home_page_controller/home_page_controller.dart';
import 'package:gallery/view/pages/home_page/widgets/image_card.dart';
import 'package:gallery/view/utils/debouncer.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final HomePageController _controller = Get.put(HomePageController());
  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Determine crossAxisCount based on screen size
    int crossAxisCount;
    if (screenWidth >= 1100) {
      crossAxisCount = 5; // Big screen
    } else if (screenWidth >= 800) {
      crossAxisCount = 4; // Tablet
    } else {
      crossAxisCount = 2; // Mobile
    }
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Pixabay Image Gallery',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 7, 168, 255),
          ),
          body: _controller.initialIsLoading.value
              ? const SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!_controller.isLoading.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      debouncer.run(() {
                        _controller.incrementCurrentPage();
                        _controller.fetchImages();
                      });
                    }
                    return false;
                  },
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          crossAxisCount, // Adjust the number of columns
                      childAspectRatio: 1, // Adjust the aspect ratio if needed
                    ),
                    itemCount: _controller.imageList.length +
                        (_controller.isLoading.value
                            ? 1
                            : 0), // Show loading indicator if loading
                    itemBuilder: (context, index) {
                      if (index < _controller.imageList.length) {
                        return ImageCard(
                            url: _controller.imageList[index]["url"],
                            totalView: _controller.imageList[index]["views"]
                                .toString(),
                            totalLike: _controller.imageList[index]["likes"]
                                .toString());
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
        ));
  }
}
