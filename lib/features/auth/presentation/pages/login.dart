import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rescue_aircraft/features/auth/presentation/pages/register.dart';
import 'package:rescue_aircraft/utils/gradient.dart';
import 'package:rescue_aircraft/shared/widgets/button.dart';
import 'package:rescue_aircraft/shared/widgets/text.dart';
import '../../../../shared/widgets/textField.dart';
import '../../../../core/errors/failures.dart';
import '../../../../features/auth/domain/usecases/sign_in_use_case.dart';
import '../../../home/presentation/pages/home.dart';
import '../bloc/auth/auth_bloc.dart';
import 'package:rescue_aircraft/features/auth/domain/repositories/auth_repository.dart';

class SignIn extends StatefulWidget {
  final AuthRepository authRepository;
  SignIn({super.key, required this.authRepository});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  late final SignInUseCase signInUseCase;

  @override
  void initState() {
    super.initState();
    signInUseCase = SignInUseCase(widget.authRepository);
  }

  @override
  Widget build(BuildContext context) {
    // Get the SignInUseCase from the provider
    final signInUseCase = Provider.of<SignInUseCase>(context);
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Fluttertoast.showToast(msg: "Login successful!");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          } else if (state is AuthError) {
            Fluttertoast.showToast(msg: "Login failed.");
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
                        text: "Hello\nSignIn!",
                        fontColor: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 50, left: 30, right: 30),
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
                              text: "Email",
                              fontColor: Color(0xff00bfff),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 10),
                            MyTextField(
                              controllerName: emailController,
                              hintText: "Enter Email",
                              icon: Icons.email_outlined,
                              fillColor: Colors.grey[100],
                              iconSize: 25,
                              iconColor: Colors.blueAccent,
                            ),
                            SizedBox(height: 25),
                            MyText(
                              text: "Password",
                              fontColor: Color(0xff00bfff),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                hintText: "Enter Password",
                                prefixIcon: Icon(
                                  Icons.lock_outlined,
                                  size: 25,
                                  color: Colors.blueAccent,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                  BorderSide(color: Colors.blueAccent, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ForgotPassword(),
                                    //   ),
                                    // );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 4, 72, 129),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 70),
                            MyButton(
                              name: "SIGN IN",
                              perform: () async {
                                final String email = emailController.text.trim();
                                final String password = passwordController.text.trim();

                                // Dispatch sign-in event to BLoC
                                context.read<AuthBloc>().add(
                                  SignInButtonPressed(
                                    email: email,
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
                            SizedBox(height: MediaQuery.of(context).size.height / 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyText(
                                  text: "Don't have an account?",
                                  fontColor: Colors.black45,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Signup(
                                          authRepository: widget.authRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  child: MyText(
                                    text: "SIGN UP",
                                    fontColor: Color.fromARGB(255, 4, 72, 129),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
        },
    );
  }
}