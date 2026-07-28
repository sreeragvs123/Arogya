
class ValidInput{
  static final RegExp email = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final RegExp phoneNumber =  RegExp(r'^[0-9]+$');
  static String? minCheck({required String type,required int min,required String value}){
    if(value.length>=min)return null;
    return "$type requires atleast $min characters";
  }

}


