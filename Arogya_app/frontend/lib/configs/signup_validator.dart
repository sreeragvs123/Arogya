import "package:frontend/constants/input_constant.dart";
class SignUpValidator{

  static String? validator({required String value,required String type}){
      value = value.trim();
      switch(type){
        case 'Name':
        case 'PhoneNo':
          final phoneRegex = ValidInput.phoneNumber;
          if(phoneRegex.hasMatch(value))return null;
          return "Enter a valid phone number";
        case 'Email':
          final emailRegex = ValidInput.email;
          if(emailRegex.hasMatch(value))return null;
          return "Enter a valid email";
        case 'Username':
          return ValidInput.minCheck(type:type,min:5, value:value);
        case 'Password':
          return ValidInput.minCheck(type:type,min:6,value:value);
      }
      return null;
      }
  }


