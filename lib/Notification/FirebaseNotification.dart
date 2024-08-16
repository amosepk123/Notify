import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseController extends GetxController {

  // var FCM = ''.obs; // Correctly declare FCM as an RxString
  final _firebaseMessaging = FirebaseMessaging.instance;
  var putName=''.obs;
  var putPhone=''.obs;
  var putEmail=''.obs;



  var FCM=''.obs;

  var id = ''.obs;
  var token = ''.obs;
  var name = ''.obs;
  var phone = ''.obs;
  var emailId = ''.obs;
  var withoutCoutryCodePhoneNumber=''.obs;

  void setData(String? id, String? token, String? name, String? emailId) {
    this.id.value = id ?? '';
    this.token.value = token ?? '';
    this.name.value = name ?? '';
    this.emailId.value = emailId ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    initNotifications();
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token: $fCMToken");
    FCM.value=fCMToken!;

    //FCM.value = fCMToken ?? ''; // Correctly set the value of the RxString
    FirebaseMessaging.onBackgroundMessage(_handlerBackGroundMessage);
  }

  static Future<void> _handlerBackGroundMessage(RemoteMessage message) async {
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Payload: ${message.data}");
  }
}
