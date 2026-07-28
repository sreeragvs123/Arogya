class SignUp{
  String name;
  String username;
  String email;
  String password;
  String role;

  SignUp({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.role
  });

  Map<String,dynamic> toJson() => {
    'name' : name,
    'username' : username,
    'email' : email,
    'password' : password,
    'role' : role
  };

}


class LoginRequest{
  String username;
  String password;
  String role;

  LoginRequest({
    required this.username,
    required this.password,
    required this.role
  });

  Map<String,dynamic> toJson() => {
    'username' : username,
    'password' : password,
    'role' : role

  };

}


class LoginResponse{

  String accessToken;
  String refreshToken;

  LoginResponse({

    required this.accessToken,
    required this.refreshToken
  });

factory LoginResponse.fromJson(Map<String, dynamic> json) {
  final data = json['data'] as Map<String, dynamic>;
  return LoginResponse(
    accessToken: data['accessToken'] as String,
    refreshToken: data['refreshToken'] as String,
  );
}
}

