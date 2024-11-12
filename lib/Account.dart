class Account{
  late String email;
  late String password;

  Account(this.email,this.password);

  Map<String, dynamic> toMap(){
    return {
      'email':email,
      'password':password
    };
  }

  Account.fromMap(Map<String,dynamic> map){
    email = map['email'];
    password = map['password'];
  }
}