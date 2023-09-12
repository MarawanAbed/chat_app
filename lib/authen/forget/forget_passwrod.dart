import 'package:chat_app/authen/forget/cubit/forget_password_cubit.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordLoading) {
            const Center(child: CircularProgressIndicator());
          }
          if (state is ForgetPasswordSuccess) {
            Utils.showSnackBar('Check your email',);
          }
          if (state is ForgetPasswordFailure) {
            Utils.showSnackBar(state.error,);
          }
        },
        builder: (context, state) {
          var cubit = ForgetPasswordCubit.get(context);
          return Scaffold(
            body: Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        myLogo(context),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Forget Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Wrap(
                          children: [
                            Text(
                                'Provide your email and we will send you a link to reset your password ')
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AuthFormField(
                          labelText: 'email',
                          prefixIcon: Icons.email,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Email can not be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.resetPassword(email: emailController.text);
                            }
                          },
                          child: const Text(
                            'Reset Password',
                            style:
                            TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Go back',
                            style:
                            TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )
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
