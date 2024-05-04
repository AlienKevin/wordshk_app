import 'dart:convert';

import 'package:aws_cognito_identity_api/cognito-identity-2014-06-30.dart';
import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/services.dart';

class AwsService {
  static const String identityPoolId =
      "ap-southeast-1:927c2cdb-f6dc-4e4e-9bc1-7b5e83f1d795";
  static const String region = "ap-southeast-1";
  static const String queueUrl =
      "https://sqs.ap-southeast-1.amazonaws.com/999404134598/wordshk";

  Future<SQS?> getSQSClient() async {
    // Initialize Cognito Identity client
    final cognitoIdentity = CognitoIdentity(region: region);

    // Get credentials
    late final AwsClientCredentials credentials;
    try {
      final getIdResponse =
          await cognitoIdentity.getId(identityPoolId: identityPoolId);
      if (getIdResponse.identityId == null) {
        print("aws_service.dart: AWS Cognito getId failed to fetch identityId");
        return null;
      }

      final response = await cognitoIdentity.getCredentialsForIdentity(
        identityId: getIdResponse.identityId!,
        // Additional parameters if needed
      );
      if (response.credentials == null ||
          response.credentials?.accessKeyId == null ||
          response.credentials?.secretKey == null) {
        print("aws_service.dart: AWS Cognito failed to fetch credentials");
        return null;
      } else {
        credentials = AwsClientCredentials(
          accessKey: response.credentials!.accessKeyId!,
          secretKey: response.credentials!.secretKey!,
          sessionToken: response.credentials!.sessionToken,
        );
      }
    } catch (e) {
      print("aws_service.dart:\n$e");
      return null;
    }

    // Create SQS client with the obtained credentials
    final sqs = SQS(
      region: region,
      credentials: credentials,
    );

    return sqs;
  }

  Future<bool> sendMessage(String messageBody) async {
    final sqs = await getSQSClient();

    if (sqs == null) {
      return false;
    }

    try {
      var response = await sqs.sendMessage(
        queueUrl: queueUrl,
        messageBody: messageBody,
      );
      if (response.messageId == null) {
        print("aws_service.dart: AWS SQS failed to send message");
        return false;
      }
      print('Message sent: $messageBody');
      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }
}
