class userModel{
  final String username;
  final String useremail;
  final String password;
  final String uid;

  const userModel({
    required this.username,
    required this.useremail,
    required this.password,
    required this.uid
});


  toJson(){
    return{
      "Username":username,
      "UserEmail":useremail,
      "Password":password,
      "Uid":uid,
    };
  }

}



