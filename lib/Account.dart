class Account{
  late String username;
  late String password;

  Account(this.username,this.password);

  Map<String, dynamic> toMap(){
    return {
      'username':username,
      'password':password
    };
  }

  Account.fromMap(Map<String,dynamic> map){
    username = map['username'];
    password = map['password'];
  }
}