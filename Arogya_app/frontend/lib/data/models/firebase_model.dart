class MessageToken{
  String token;
  MessageToken({required this.token});

  Map<String,dynamic> toJson()=>{
    "messageToken" : token
  };

}