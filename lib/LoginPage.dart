import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  Future<bool> registerUser(Account acc) async{
    return database.registerUser(acc);
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
                      currentUser = (await database.getUser(_usernameController.text, _passwordController.text))!;
                      // If the form is valid, proceed to the HomeScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context)  => HomeScreen(currentUser)),
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
              ElevatedButton(onPressed: ()async {
                currentUser = Account(_usernameController.text, _passwordController.text);
                if(!await registerUser(currentUser)){
                  showDialog(context: context, builder: (context)=>AlertDialog(
                    title: const Text('ERROR: Username already exists.'),
                    actions: [
                      TextButton(onPressed: ()=>Navigator.pop(context, 'OK'), child: const Text("OK"))
                    ],
                  ));
                }
                else{
                  currentUser = (await database.getUser(_usernameController.text, _passwordController.text))!;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(currentUser)));
                }
              }, child: const Text("Register user"))
            ],
          ),
        ),
      ),
    );
  }
}
