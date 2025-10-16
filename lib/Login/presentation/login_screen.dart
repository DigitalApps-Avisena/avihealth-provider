import 'package:avihealth_provider/home.dart';
import 'package:avihealth_provider/login/logic/login_notifier.dart';
import 'package:avihealth_provider/login/model/login_response.dart';
import 'package:avihealth_provider/shared/app_awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);

    ref.listen<AsyncValue<LoginResponse?>>(loginProvider, (prev, next) {
      next.whenOrNull(
        data: (data) {
          if (data?.code == '1') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (data?.code == '01') {
            AppAwesomeDialog.showError(context, title: "Login failed", desc: "Email not found");
          } else if (data?.code == '02') {
            AppAwesomeDialog.showError(context, title: "Login failed", desc: "Wrong password");
          } else if (data?.code == '03') {
            AppAwesomeDialog.showError(context, title: "Account inactive", desc: "Please contact admin");
          }
        },
        error: (err, _) {
          AppAwesomeDialog.showError(context, title: "Error", desc: err.toString());
        },
      );
    });

    return Scaffold(
      body: Column(
        children: [
          TextField(controller: emailController, decoration: const InputDecoration(hintText: "Email")),
          TextField(controller: passwordController, decoration: const InputDecoration(hintText: "Password")),
          ElevatedButton(
            onPressed: () {
              ref.read(loginProvider.notifier).login(
                emailController.text,
                passwordController.text,
              );
            },
            child: loginState.isLoading ? const CircularProgressIndicator() : const Text("Login"),
          ),
        ],
      ),
    );
  }
}