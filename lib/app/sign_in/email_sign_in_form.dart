import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/form_submit_button.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({@required this.auth});
  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  bool _submitted = false;
  bool _isLoading = false;

  void _onEditingComplete() {
    final focus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(focus);
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmail(_email, _password);
      } else {
        await widget.auth.createAccountWithEmail(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (error) {
      print(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = (_formType == EmailSignInFormType.signIn)
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _updateState() {
    setState(() {});
  }

  List<Widget> _buildChildren() {
    final primaryText = (_formType == EmailSignInFormType.signIn)
        ? 'Sign In'
        : 'Create an Account';
    final secondaryText = (_formType == EmailSignInFormType.signIn)
        ? 'Need an account? Register'
        : 'Have an account? Sign In';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: (submitEnabled) ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(secondaryText),
        onPressed: (!_isLoading) ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'abc@example.com',
        errorText: (showErrorText) ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _onEditingComplete,
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter password',
        errorText: (showErrorText) ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
