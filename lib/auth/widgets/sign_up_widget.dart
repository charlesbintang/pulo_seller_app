import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../methods/common_methods.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/loading_dialog.dart';
import '../../base_widgets/button/custom_button.dart';
import '../../base_widgets/text_field/custom_password_textfield.dart';
import '../../base_widgets/text_field/custom_textfield.dart';
import '../../pages/dashboard.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  SignUpWidgetState createState() => SignUpWidgetState();
}

class SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkAvailable() {
    cMethods.checkConnectivity(context);

    signUpFormValidation();
  }

  signUpFormValidation() {
    if (userNameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackBar(
        "Your name must be atleast 4 or more characters.",
        context,
      );
    } else if (userPhoneTextEditingController.text.trim().length < 7) {
      cMethods.displaySnackBar(
        "Your number phone must be atleast 8 or more characters.",
        context,
      );
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar(
        "Please write valid email",
        context,
      );
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
        "Your password must be atleast 6 or more characters.",
        context,
      );
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registering account..."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
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

    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

    Map userDataMap = {
      "name": userNameTextEditingController.text.trim(),
      "phone": userPhoneTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };

    usersRef.set(userDataMap);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => const Dashboard(
                  initIndex: 0,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      children: [
        Form(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomTextField(
                      hintText: 'Name',
                      textInputType: TextInputType.name,
                      isPhoneNumber: false,
                      capitalization: TextCapitalization.words,
                      controller: userNameTextEditingController,
                    )),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault,
                    top: Dimensions.marginSizeSmall),
                child: CustomTextField(
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  controller: emailTextEditingController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault,
                    top: Dimensions.marginSizeSmall),
                child: CustomTextField(
                  hintText: 'Number Phone',
                  textInputType: TextInputType.phone,
                  controller: userPhoneTextEditingController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault,
                    top: Dimensions.marginSizeSmall),
                child: CustomPasswordTextField(
                  hintTxt: 'Password',
                  controller: passwordTextEditingController,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
              left: Dimensions.marginSizeLarge,
              right: Dimensions.marginSizeLarge,
              bottom: Dimensions.marginSizeLarge,
              top: Dimensions.marginSizeLarge),
          child: CustomButton(
              onTap: () => checkIfNetworkAvailable(), buttonText: 'Sign Up'),
        ),
      ],
    );
  }
}
