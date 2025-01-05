import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rescue_aircraft/providers/auth_provider.dart';
import 'package:rescue_aircraft/screens/home.dart';
import 'package:rescue_aircraft/screens/login.dart';
import 'package:http/http.dart' as http;
import 'package:rescue_aircraft/utils/constant.dart';
import 'package:rescue_aircraft/utils/gradient.dart';
import 'package:rescue_aircraft/widgets/button.dart';
import 'package:rescue_aircraft/widgets/textField.dart';

import '../widgets/text.dart';

class Signup extends StatefulWidget {
  const Signup({super.key
  });

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final TextEditingController confirmPasswordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 30,),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient:kBlueGradient
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: MyText(
                    text: "Register User",
                    fontColor: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                )
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20,left: 30,right: 30),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                          text: "Name",
                          fontColor: Color(0xff00bfff),
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      MyTextField(controllerName: nameController,
                          hintText: "Enter Name",
                          icon: Icons.person_outlined,
                          fillColor: Colors.grey[100],
                          iconSize: 25,
                          iconColor: Colors.blueAccent
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyText(
                          text: "Email",
                          fontColor: Color(0xff00bfff),
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      MyTextField(
                          controllerName: emailController,
                          hintText: "Enter Email",
                          icon: Icons.email_outlined,
                          fillColor: Colors.grey[100],
                          iconSize: 25,
                          iconColor: Colors.blueAccent
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyText(
                          text: "Password",
                          fontColor: Color(0xff00bfff),
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      MyTextField(
                          controllerName: passwordController,
                          hintText: "Enter Password",
                          icon: Icons.lock_outline_rounded,
                          fillColor: Colors.grey[100],
                          iconSize: 25,
                          iconColor: Colors.blueAccent
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyText(
                          text: "Confirm Password",
                          fontColor: Color(0xff00bfff),
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      MyTextField(
                          controllerName: confirmPasswordController,
                          hintText: "Enter Password",
                          icon: Icons.lock_outline_rounded,
                          fillColor: Colors.grey[100],
                          iconSize: 25,
                          iconColor: Colors.blueAccent
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      MyButton(
                          name: "SIGN UP",
                          perform: () async {
                            final String name = nameController.text.trim();
                            final String email = emailController.text.trim();
                            final String password = passwordController.text.trim();
                            final String confirmPassword = confirmPasswordController.text.trim();

                            if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                              Fluttertoast.showToast(msg: "All fields are required.");
                              return;
                            }

                            if (password != confirmPassword) {
                              Fluttertoast.showToast(msg: "Passwords do not match.");
                              return;
                            }

                            bool isSuccess = await authProvider.register(name, email, password);

                            if (isSuccess) {
                              Fluttertoast.showToast(msg: "Registration successful!");
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => Home()));
                            } else {
                              Fluttertoast.showToast(msg: authProvider.errorMessage);
                            }
                          },
                          btnHeight: 60,
                          btnWidth: MediaQuery.of(context).size.width,
                          nameColor: Colors.white,
                          nameSize: 24,
                          nameWeight: FontWeight.bold
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/7,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyText(
                              text: "Already have an account?",
                              fontColor: Colors.black45,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                            },
                            child: MyText(
                                text: "SIGN IN",
                                fontColor: Color.fromARGB(255, 4, 72, 129),
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }

