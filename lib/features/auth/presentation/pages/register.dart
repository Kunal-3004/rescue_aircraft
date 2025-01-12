import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue_aircraft/shared/widgets/button.dart';
import 'package:rescue_aircraft/shared/widgets/textField.dart';
import 'package:rescue_aircraft/shared/widgets/text.dart';
import 'package:rescue_aircraft/features/auth/domain/repositories/auth_repository.dart';

import '../../../../utils/gradient.dart';
import '../../../home/presentation/pages/home.dart';
import '../../domain/usecases/sign_up_use_case.dart';
import '../bloc/auth/auth_bloc.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  final AuthRepository authRepository;
  const Signup({super.key, required this.authRepository});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final SignUpUseCase signUpUseCase;

  @override
  void initState() {
    super.initState();
    signUpUseCase = SignUpUseCase(widget.authRepository); // Initialize use case with repository
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Fluttertoast.showToast(msg: "Registration successful!");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else if (state is AuthError) {
          Fluttertoast.showToast(msg: "Registration failed.");
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 30),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(gradient: kBlueGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: MyText(
                      text: "Register User",
                      fontColor: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Name",
                            fontColor: Color(0xff00bfff),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 7),
                          MyTextField(
                            controllerName: _nameController,
                            hintText: "Enter Name",
                            icon: Icons.person_outlined,
                            fillColor: Colors.grey[100],
                            iconSize: 25,
                            iconColor: Colors.blueAccent,
                          ),
                          const SizedBox(height: 10),
                          MyText(
                            text: "Email",
                            fontColor: Color(0xff00bfff),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 7),
                          MyTextField(
                            controllerName: _emailController,
                            hintText: "Enter Email",
                            icon: Icons.email_outlined,
                            fillColor: Colors.grey[100],
                            iconSize: 25,
                            iconColor: Colors.blueAccent,
                          ),
                          const SizedBox(height: 10),
                          MyText(
                            text: "Password",
                            fontColor: Color(0xff00bfff),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 7),
                          MyTextField(
                            controllerName: _passwordController,
                            hintText: "Enter Password",
                            icon: Icons.lock_outline_rounded,
                            fillColor: Colors.grey[100],
                            iconSize: 25,
                            iconColor: Colors.blueAccent,
                          ),
                          const SizedBox(height: 10),
                          MyText(
                              text: "Full Name",
                            fontColor: Color(0xff00bfff),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 7),
                          MyTextField(
                            controllerName: _fullNameController,
                            hintText: "Enter Full Name",
                            icon: Icons.lock_outline_rounded,
                            fillColor: Colors.grey[100],
                            iconSize: 25,
                            iconColor: Colors.blueAccent,
                          ),
                          const SizedBox(height: 40),
                          MyButton(
                            name: "SIGN UP",
                            perform: () async {
                              final String name = _nameController.text.trim();
                              final String email = _emailController.text.trim();
                              final String password = _passwordController.text.trim();
                              final String fullName = _fullNameController.text.trim();


                              // Dispatch sign-up event to BLoC
                              context.read<AuthBloc>().add(
                                SignUpButtonPressed(
                                  name: name,
                                  email: email,
                                  fullName: fullName,
                                  password: password,
                                ),
                              );
                            },
                            btnHeight: 60,
                            btnWidth: MediaQuery.of(context).size.width,
                            nameColor: Colors.white,
                            nameSize: 24,
                            nameWeight: FontWeight.bold,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height / 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                text: "Already have an account?",
                                fontColor: Colors.black45,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn(
                                    authRepository: widget.authRepository,
                                  )));
                                },
                                child: MyText(
                                  text: "SIGN IN",
                                  fontColor: Color.fromARGB(255, 4, 72, 129),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
      },
    );
  }
}
