import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rescue_aircraft/screens/login.dart';
import 'package:rescue_aircraft/widgets/button.dart';
import 'package:rescue_aircraft/widgets/text.dart';
import 'package:rescue_aircraft/widgets/textField.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController=TextEditingController();

  Future<void> sentEmail() async{

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 30,),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff87ceeb),
              Color(0xff00bfff),
              Color(0xff4682b4),
            ],begin: Alignment.topLeft,end: Alignment.topRight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                  },
                  child: Icon(Icons.arrow_back_ios,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 60,top: 5),
                child: Row(
                  children: [
                    MyText(
                        text: "FORGOT PASSWORD",
                        fontColor:Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 50,left: 30,right: 30),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock,
                            size: 150,
                            color: Color(0xff00bfff),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.key,
                            size: 50,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MyText(
                          text: "Email",
                          fontColor: Color(0xff00bfff),
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                          controllerName: emailController,
                          hintText: "Enter Email",
                          icon: Icons.email_outlined,
                          fillColor: Colors.grey[100],
                          iconSize: 25,
                          iconColor: Colors.blueAccent
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      MyButton(
                          name: "SENT",
                          perform: sentEmail,
                          btnHeight: 60,
                          btnWidth: MediaQuery.of(context).size.width,
                          nameColor: Colors.white,
                          nameSize: 24,
                          nameWeight: FontWeight.bold
                      ),
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
