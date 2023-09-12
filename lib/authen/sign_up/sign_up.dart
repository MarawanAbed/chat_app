import 'package:chat_app/authen/sign_in/sign_in.dart';
import 'package:chat_app/authen/sign_up/cubit/sign_up_cubit.dart';
import 'package:chat_app/authen/verify/verifiy_email.dart';
import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();

    var userNameController = TextEditingController();

    var passwordController = TextEditingController();

    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpLoading) {
            const Center(child: CircularProgressIndicator());
          }
          if(state is SignUpCreateUserSuccessState)
          {
            navigateWithoutBack(context, const VerifyEmail());
          }
        },
        builder: (context, state) {
          var cubit = SignUpCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          height: 80,
                        ),
                        myLogo(context),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        AuthFormField(
                          labelText: 'User Name',
                          prefixIcon: Icons.person,
                          controller: userNameController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your user name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        AuthFormField(
                          labelText: 'Email',
                          prefixIcon: Icons.email,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        AuthFormField(
                          labelText: 'Password',
                          prefixIcon: Icons.lock,
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                          obscureText: cubit.isVisible,
                          suffixIcon: IconButton(
                            icon: Icon(cubit.suffix),
                            onPressed: cubit.changePasswordVisibility,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.userRegister(
                                email: emailController.text,
                                password: passwordController.text,
                                userName: userNameController.text,
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: kPrimaryColor,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'have an account? ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                navigateWithoutBack(context, const SignIn());
                              },
                              child: Text(
                                'Sign In ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
