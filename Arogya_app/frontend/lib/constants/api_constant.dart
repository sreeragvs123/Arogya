class ApiConstants{
  
  static const String serverIp = '10.146.21.26';
  static const String port = '8080';
  static const String baseUrl = 'http://$serverIp:$port';


  //Authetication URL
  static const String signUp = '$baseUrl/auth/signUp';
  static const String signOut = '$baseUrl/auth/signOut';
  static const String login = '$baseUrl/auth/login';
  
}