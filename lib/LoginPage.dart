import 'package:flutter/material.dart';
import 'Account.dart';
import 'HomePage.dart';
import 'package:final_project/Database.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Account currentUser;

  Database database = Database();

  Future<bool> validateLogin(String username, String password) async{
    var accountMap = await database.getUser(username, password);
    if(accountMap == null) {
      return false;
    }
    else {
      currentUser = accountMap;
      print("TEST USER: ${currentUser}");
      return true;
    }
  }

  Future<bool> registerUser(String username, String password) async{
    return database.registerUser(username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    print("LOGGING IN............................................................");
                    print("USERNAME: ${_usernameController.text}, PASSWORD: ${_passwordController.text}");
                    if(!await validateLogin(_usernameController.text,_passwordController.text)){
                      showDialog(context: context,
                          builder: (BuildContext context)=> AlertDialog(
                            title: Text("INVALID Username and Password"),
                            actions: [
                              TextButton(onPressed: ()=>Navigator.pop(context, 'OK'), child: Text("OK"))
                            ],
                          )
                      );
                    }
                    else{
                      // If the form is valid, proceed to the HomeScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
              ElevatedButton(onPressed: ()async {
                if(!await registerUser(_usernameController.text, _passwordController.text)){
                  showDialog(context: context, builder: (context)=>AlertDialog(
                    title: const Text('ERROR: Username already exists.'),
                    actions: [
                      TextButton(onPressed: ()=>Navigator.pop(context, 'OK'), child: const Text("OK"))
                    ],
                  ));
                }
                else{
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                }
              }, child: const Text("Register user"))
            ],
          ),
        ),
      ),
    );
  }
}
