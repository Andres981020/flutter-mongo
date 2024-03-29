import 'package:flutter/material.dart';
import 'package:flutter_todo/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/realm/app_services.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isLogin = true;
  String? _errorMessage;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController()..addListener(clearError);
    _passwordController = TextEditingController()..addListener(clearError);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.only(top: 30),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(_isLogin ? 'Log In' : 'Sign Up', style: const TextStyle(fontSize: 25)),
                loginField(_emailController, labelText: "EmailPrueba", hintText: "Ingrese un email valido ej: abc@gmail.com"),
                loginField(_passwordController, labelText: "PasswordPrueba", hintText: "Ingrese una contraseña", obscure: true),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Text(
                      "Ingrese o registrese con un usuario sincronizado.",
                      textAlign: TextAlign.center),
                ),
                loginButton(context,
                    child: Text(
                      _isLogin ? "Ingresar" : "Registrar"),
                    onPressed: () => _logInOrSignUpUser(context,
                        _emailController.text, _passwordController.text)),
                TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(
                      _isLogin ? "Nuevo en la app? Registrate" : 'Ya tienes cuenta? Ingresa.',
                    )),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(_errorMessage ?? "",
                      style: errorTextStyle(context),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clearError() {
    if (_errorMessage != null) {
      setState(() {
        // Reset error message when user starts typing
        _errorMessage = null;
      });
    }
  }

  void _logInOrSignUpUser(BuildContext context, String email, String password) async {
    final appServices = Provider.of<AppServices>(context, listen: false);
    clearError();
    try {
      if (_isLogin) {
        await appServices.logInUserEmailPassword(email, password);
      } else {
        await appServices.registerUserEmailPassword(email, password);
      }
      Navigator.pushNamed(context, '/');
    } catch (err) {
      setState(() {
        _errorMessage = err.toString();
      });
    }
  }
}
