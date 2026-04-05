import "package:flutter/material.dart";
import "package:frontend/api/auth_api.dart";
import "package:frontend/models/auth_model.dart";
import "package:hive/hive.dart";


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController usernameController =  TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  
  // ignore: prefer_final_fields
  bool _isLoading = false;

  Future<void> login() async{
    if(!_formkey.currentState!.validate())return;
    setState(() { _isLoading = true; });
    try{
      final resp = await AuthApi.login(LoginRequest(
          username:usernameController.text.trim(),
          password:passwordController.text.trim(),
          role:'PATIENT'
        )
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Successfull Login'),
          backgroundColor: Colors.green,
        ),
      );
      _navigateHome(resp);
    }catch(e){
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(//context of signUpPage
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
    finally {
        if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateHome(LoginResponse resp){
    Box box = Hive.box("authBox");
    box.put('accessToken',resp.accessToken);
    box.put('refreshToken',resp.refreshToken);
    Navigator.pushNamed(context, '/frontpage');//context of SignUpPage
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 66, 201, 71),const Color.fromARGB(255, 111, 255, 116)],
              begin:Alignment.topLeft,
              end:Alignment.bottomRight
            ),
          ),
          child:Padding(
            padding: const EdgeInsets.all(26.0),
            child: Center(
              child:SingleChildScrollView(
                child:Column(
                  children: [
                    Text("AROGYA",
                      style:TextStyle(
                        color:const Color.fromARGB(255, 255, 255, 255),
                        fontSize:38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0, // how blurry the shadow is
                            color: const Color.fromARGB(255, 113, 113, 113), // shadow color
                            offset: Offset(3, 3), // position (x,y)
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height:40),
                    Card(
                      elevation:10,
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color:Colors.white,
                      child:Padding(
                        padding: const EdgeInsets.only(left:10,top:20,right:10,bottom:20),
                        child:Form(
                          key:_formkey,
                          child: Column(
                            children:[
                              Text("Login",
                                style:TextStyle(
                                  fontSize:26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1
                                )
                              ),
                              const SizedBox(height:30),
                                              
                              TextFormField(
                                controller:usernameController,
                                decoration: InputDecoration(
                                  labelText:"Username",
                                  border:OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                ),
                                style:TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18
                                )
                              ),
                              const SizedBox(height:17),
                                              
                              TextFormField(
                                controller:passwordController,
                                decoration: InputDecoration(
                                  labelText:"Password",
                                  border:OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                ),
                                style:TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18
                                )
                              ),
                              const SizedBox(height:30),
                              SizedBox(
                                width: 300,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: _isLoading ? null : login,
                                  child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            "SUBMIT",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                )
                              ),
                              const SizedBox(height:25),
                              InkWell(
                                onTap:(){
                                  Navigator.pushNamed(context,'/signup');
                                },
                                child:Text(
                                  "Don't Have an Account ? Sign Up",
                                  style:TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color:Color.fromARGB(255, 0, 108, 29)
                                  )
                                  
                                )
                              )
                            ]
                          ),
                        ),
                      )
                    ),
                  ],
                )
              )
            ),
      )
      )
    );
  }
}