import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

import 'package:boysbrigade/pages/signup.dart';

// TODO: PLEASE REMOVE ME WHEN DONE
const bool TMP_DEBUG_FLAG = false;

class Login extends GetWidget<AuthController> {
  Login({Key? key}) : super(key: key);

  // TODO: REMOVE DEFAULT TESTING VALUES
  final RxString email = TMP_DEBUG_FLAG ? 'ss@bb78.com'.obs : ''.obs;
  final RxString password = TMP_DEBUG_FLAG ? 'ss1234'.obs : ''.obs;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Future<String?> attemptLogin(String email, String password) async {
    String? errMessage;
    try {
      await controller.loginTeacher(email, password);

      final UserController userCtrl = Get.find<UserController>();

      // HACK: This delayed checking loop is so that the rest of the teacher
      // data has time to load in before we render the home page.

      // This also "solves" the issue where the user has *just* logged in
      // but the teacher data isn't loaded in as of yet.

      // NOTE: This is most probably a bad practice, but it works for now
      await FutureUtils.waitFor(
          () => userCtrl.hasData, const Duration(milliseconds: 50));
      errMessage = null;
    } on FirebaseAuthException catch (err) {
      errMessage = err.message ?? 'Unknown error code: ${err.code}!';
    } on Exception catch (err) {
      errMessage = err.toString();
    }

    return errMessage;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 50, 40, 0),
            child: Form(
              // TODO: Really should be using Column but too lazy to style login button to fill width for now...
              key: loginFormKey,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/logo.png',
                    height: 180,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    initialValue: email.value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.grey[200],
                      hintText: 'enter email'.tr,
                      filled: true,
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String newValue) => email.value = newValue,
                    validator: ValidationBuilder()
                        .required('email required'.tr)
                        .email('invalid email'.tr)
                        .build(),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: password.value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'enter password'.tr,
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[700]),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    onChanged: (String newValue) => password.value = newValue,
                    obscureText: true,
                    validator: ValidationBuilder()
                        .required('password required'.tr)
                        .build(),
                  ),
                  const SizedBox(height: 30),
                  RaisedButton(
                    child: Text(
                      'login'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                    shape: const RoundedRectangleBorder(),
                    color: Colors.black,
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    onPressed: () async {
                      if (loginFormKey.currentState!.validate()) {
                        final String? errMessage =
                            await Get.dialog<String?>(FutureProgressDialog(
                          attemptLogin(email.value, password.value),
                          message: Text('loading'.tr),
                        ));

                        if (errMessage != null) {
                          Get.rawSnackbar(
                              title: 'login failed'.tr, message: errMessage);
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  RaisedButton(
                    child: Text(
                      'signup'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                    shape: const RoundedRectangleBorder(),
                    color: Colors.black,
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    onPressed: () async {
                      await Get.to<void>(() => Signup());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
