import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pulo_seller_app/widgets/input_password_widget.dart';

import '../../../global/global_var.dart';
import '../../../methods/common_methods.dart';
import '../../../utils/color_resources.dart';
import '../../../utils/custom_themes.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/loading_dialog.dart';
import '../../base_widgets/button/custom_button.dart';
import '../../pages/dashboard.dart';
import '../../utils/constants.dart';
import '../../widgets/input_widget.dart';

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
            Navigator.pushReplacement(
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
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 0.0,
              top: -20.0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/images/logo_small.png",
                  scale: 6,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Log in to your account",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40.0),
                  ),
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 180.0,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.marginSizeLarge),
                        child: Form(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeSmall),
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    bottom: Dimensions.marginSizeSmall),
                                child: InputWidget(
                                  topLabel: "Email",
                                  hintText: "Enter your email address",
                                  textInputType: TextInputType.emailAddress,
                                  controller: emailTextEditingController,
                                ),
                                // CustomTextField(
                                //   hintText: 'Email',
                                //   textInputType: TextInputType.emailAddress,
                                //   controller: emailTextEditingController,
                                // ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      bottom: Dimensions.marginSizeDefault),
                                  child: InputPasswordWidget(
                                    topLabel: "Password",
                                    hintText: "Enter your password",
                                    textInputAction: TextInputAction.done,
                                    controller: passwordTextEditingController,
                                  )
                                  //     CustomPasswordTextField(
                                  //   hintTxt: 'Password',
                                  //   textInputAction: TextInputAction.done,
                                  //   controller: passwordTextEditingController,
                                  // ),
                                  ),
                              Container(
                                margin: const EdgeInsets.only(
                                    right: Dimensions.marginSizeSmall),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Text('Forgot Password',
                                          style: titilliumRegular.copyWith(
                                              color: ColorResources
                                                  .getLightSkyBlue(context))),
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
                              const SizedBox(
                                  width: Dimensions.paddingSizeDefault),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
