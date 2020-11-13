import 'package:cloud_functions/cloud_functions.dart';

class Funcs {
  // static Future<Map<dynamic, dynamic>> notifyUserOf(
  //     {String functionName, Map<dynamic, dynamic> data}) async {
  //   final HttpsCallable httpsCallable = CloudFunctions.instance
  //       .getHttpsCallable(functionName: functionName)
  //         ..timeout = const Duration(seconds: 30);
  //   HttpsCallableResult httpsCallableResult;
  //   try {
  //     httpsCallableResult = await httpsCallable.call(data);
  //   } on CloudFunctionsException catch (e) {
  //     print('caught firebase functions exception');
  //     print(e.code);
  //     print(e.message);
  //     print(e.details);
  //   } catch (e) {
  //     print('caught generic exception');
  //     print(e);
  //   }

  //   return httpsCallableResult.data as Map<dynamic, dynamic>;
  // }
}
