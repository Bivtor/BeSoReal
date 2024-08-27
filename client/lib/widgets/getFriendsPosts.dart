import 'package:aws_s3_client/aws_s3_client.dart';

class S3Service {
  final String accessKey;
  final String secretKey;
  final String region;
  final String bucketName;

  late S3 s3client;

  S3Service({
    required this.accessKey,
    required this.secretKey,
    required this.region,
    required this.bucketName,
  }) {
    s3client = S3(
      region: region,
      bucketId: bucketName,
      awsAccessKey: accessKey,
      awsSecretKey: secretKey,
    );
  }

  Future<void> uploadFile(String filePath, String key) async {
    try {
      await s3client.uploadFile(
        filePath,
        key,
      );
      print('File uploaded successfully.');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<void> downloadFile(String key, String downloadPath) async {
    try {
      await s3client.downloadFile(
        key,
        downloadPath,
      );
      print('File downloaded successfully.');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<void> listObjects() async {
    try {
      final result = await s3client.listObjects();
      result.contents?.forEach((object) {
        print('Object key: ${object.key}');
      });
    } catch (e) {
      print('Error listing objects: $e');
    }
  }
}
