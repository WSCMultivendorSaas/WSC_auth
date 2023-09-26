import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wsc_auth/src/features/signup/data/models/signup_failed.dart';
import 'package:wsc_auth/src/features/signup/data/models/user_model.dart';
import 'package:wsc_auth/src/features/signup/signup_params.dart';
import 'package:wsc_auth/utilities/api_client.dart';

abstract class SignUpDataSource {
  Future<Either<SignupFailed, UserModel>> signUp(SignupParamsInterface params);
}

class SignUpDataSourceImpl extends SignUpDataSource {
  final ApiClient apiClient;
  final String signUpPath;

  SignUpDataSourceImpl({required this.apiClient, required this.signUpPath});

  /// This method is used to sign up a new user
  /// takes [SignupParamsInterface] as a parameter
  /// returns [UserModel] if the request is successful
  /// returns [SignupFailed] if the request is failed
  @override
  Future<Either<SignupFailed, UserModel>> signUp(SignupParamsInterface params) async {
    Response? response;
    try {
      response = await apiClient.post(
        signUpPath,
        body: params.toJson(),
      );
      var data = ((response.data));
      return Right(data);
    } catch (e) {
      return Left(SignupFailed(message: e.toString(), code: 500));
    }
  }
}
