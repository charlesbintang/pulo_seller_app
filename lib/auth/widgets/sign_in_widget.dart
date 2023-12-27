import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../global/global_var.dart';
import '../../../methods/common_methods.dart';
import '../../../utils/color_resources.dart';
import '../../../utils/custom_themes.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/loading_dialog.dart';
import '../../base_widgets/button/custom_button.dart';
import '../../base_widgets/text_field/custom_password_textfield.dart';
import '../../base_widgets/text_field/custom_textfield.dart';
import '../../pages/dashboard.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  SignInWidgetState createState() => SignInWidgetState();
}

class SignInWidgetState extends State<SignInWidget> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  var isChecked = false;

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("please write valid email.", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "your password must be atleast 6 or more characters.", context);
    } else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Allowing you to Login..."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((errorMsg) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMsg.toString(), context);
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(userFirebase.uid);
      await usersRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["name"];
            userPhone = (snap.snapshot.value as Map)["phone"];
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => const Dashboard()));
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar(
                "you are blocked. Contact admin: galih@gmail.com", context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar(
              "your record do not exists as a User.", context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.marginSizeLarge),
        child: Form(
          child: ListView(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeSmall),
            children: [
              Container(
                  margin:
                      const EdgeInsets.only(bottom: Dimensions.marginSizeSmall),
                  child: CustomTextField(
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    controller: emailTextEditingController,
                  )),
              Container(
                margin:
                    const EdgeInsets.only(bottom: Dimensions.marginSizeDefault),
                child: CustomPasswordTextField(
                  hintTxt: 'Password',
                  textInputAction: TextInputAction.done,
                  controller: passwordTextEditingController,
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(right: Dimensions.marginSizeSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text('Forgot Password',
                          style: titilliumRegular.copyWith(
                              color: ColorResources.getLightSkyBlue(context))),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 30),
                child: CustomButton(
                    onTap: () => checkIfNetworkIsAvailable(),
                    buttonText: 'Login'),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              // const SizedBox(width: Dimensions.paddingSizeDefault),
              // Center(
              //     child: Text('OR',
              //         style: titilliumRegular.copyWith(
              //             fontSize: Dimensions.fontSizeDefault))),
              // GestureDetector(
              //   onTap: () {},
              //   child: Container(
              //     margin: const EdgeInsets.only(
              //         left: Dimensions.marginSizeAuth,
              //         right: Dimensions.marginSizeAuth,
              //         top: Dimensions.marginSizeAuthSmall),
              //     width: double.infinity,
              //     height: 40,
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //       color: Colors.transparent,
              //       borderRadius: BorderRadius.circular(6),
              //     ),
              //     child: Text('Continue as Guest',
              //         style: titleHeader.copyWith(
              //             color: ColorResources.getPrimary(context))),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
