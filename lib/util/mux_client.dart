import 'package:dio/dio.dart';
import 'constants.dart';
import 'package:videostreamapp/model/asset_data.dart';
import 'package:videostreamapp/model/video_data.dart';

class MuxClient {
  Dio _dio = Dio();

  initializeDio() {
    BaseOptions options = BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: 8000,
        receiveTimeout: 5000,
        headers: {"Content-Type": contentType});
    _dio = Dio(options);
  }

  Future<VideoData> store({String videoUrl}) async {
    Response response;

    try {
      response = await _dio.post(
        "/assets",
        data: {
          "videoUrl": videoUrl,
        },
      );
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to store video on MUX');
    }

    if (response.statusCode == 200) {
      VideoData videoData = VideoData.fromJson(response.data);

      String status = videoData.data.status;

      while (status == 'preparing') {
        print('check');
        await Future.delayed(Duration(seconds: 1));
        videoData = await checkStatus(videoId: videoData.data.id);
        status = videoData.data.status;
      }

      return videoData;
    }

    return null;
  }

  Future<VideoData> checkStatus({String videoId}) async {
    try {
      Response response = await _dio.get(
        "/asset",
        queryParameters: {
          'videoId': videoId,
        },
      );

      if (response.statusCode == 200) {
        VideoData videoData = VideoData.fromJson(response.data);

        return videoData;
      }
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to check status');
    }

    return null;
  }

  Future<AssetData> list() async {
    try {
      Response response = await _dio.get(
        "/assets",
      );

      if (response.statusCode == 200) {
        AssetData assetData = AssetData.fromJson(response.data);

        return assetData;
      }
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to retireve videos from MUX');
    }

    return null;
  }
}
