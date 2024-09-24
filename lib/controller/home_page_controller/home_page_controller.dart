import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  RxBool initialIsLoading = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  final String apiKey = '46147025-1fd2bea0215ff2f0c7df1bf49';
  final Dio dio = Dio();
  RxInt currentPage = 1.obs;
  final int perPage = 15;
  RxList imageList = [].obs;
  Future<bool> fetchImages() async {
    currentPage.value == 1 ? initialIsLoading(true) : isLoading(true);
    final String url =
        'https://pixabay.com/api/?key=$apiKey&q=nature&image_type=photo&per_page=$perPage&page=${currentPage.value}';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> hits = response.data['hits'];
        List<Map<String, dynamic>> imagesData = hits.map((hit) {
          return {
            'url': hit['largeImageURL'],
            'likes': hit['likes'],
            'views': hit['views'],
          };
        }).toList();

        imageList([...imageList, ...imagesData]);

        return true;
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    } finally {
      isLoading(false);
      initialIsLoading(false);
    }
  }

  Future<void> incrementCurrentPage() async {
    currentPage(currentPage.value + 1);
  }
}
