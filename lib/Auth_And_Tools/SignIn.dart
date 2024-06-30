import '/Auth_And_Tools/AppBar.dart';
import '/Auth_And_Tools/Models.dart';
import '/Screens/Friends/MY_Friends.dart';
import '/bloc/data_base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Auth_And_Tools/Sign_Up.dart';
import '/Auth_And_Tools/Widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  static const Route = '/SignIn';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late UserCredential userCredential;
  //late String Email, Password;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: CustomAppBar('Sign In'),
        extendBodyBehindAppBar: true, // منشان الاب بار اعطيا لون شفاف
        body: SingleChildScrollView(
            child: Stack(children: [
          topImageMethod(1),
          bottomImageMethod(1, Height),
          Column(children: [
            Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 240),
                child: Form(
                    key: formstate,
                    child: Column(
                      children: [
                        TextFormFieldMethod(
                            "Email",
                            "Email can't to be larger than 100 letter",
                            "Email can't to be less than 2 letter",
                            Icons.email,
                            "Email",
                            TextInputType.emailAddress,
                            35,
                            EmailController),
                        SizedBox(height: 15),
                        TextFormFieldMethod(
                            "Password",
                            "Password can't to be larger than 100 letter",
                            "Password can't to be less than 4 letter",
                            Icons.article,
                            "Password",
                            TextInputType.text,
                            35,
                            PasswordController),
                        SizedBox(height: 15),
                        GoToSignMethod(
                            context, "Don't havan an account ? ", SignUp.Route),
                        SizedBox(height: 15),
                        InkWell(
                            child: SignButtonMethod("Sign in"),
                            onTap: () async {
                              var formdata = formstate.currentState;
                              if (formdata!.validate()) {
                                formdata.save();
                                print(EmailController.text.toString());
                                print(PasswordController.text.toString());
                                print("Password ++++++++++++++++++++++");
                                BlocProvider.of<DataBaseBloc>(context).add(
                                    SignInEvent(
                                        Email: EmailController.text.toString(),
                                        Password:
                                            PasswordController.text.toString(),
                                        context: context));
                              } else {
                                print("Not Vaild");
                              }
                            })
                      ],
                    )))
          ])
        ])));
  }
}
//   TextFormField TextFormFieldMethod(
//     String value,
//     String validator1,
//     String validator2,
//     IconData icon,
//     String label,
//   ) {
//     return TextFormField(
//         style: TextStyle(color: Colors.black),
//         onChanged: (String val) {
//           if (value == "Email") {
//             Email = val;
//           }
//           if (value == "Password") {
//             Password = val;
//           }
//         },
//         validator: (val) {
//           if (val!.length > 100) {
//             return validator1;
//           }
//           if (val.length < 2) {
//             return validator2;
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//             prefixIcon: Icon(icon,
//                 color: Colors.orange,
//                 size: label == "ClinicPlace" || label == "ClinicPlace_inEnglish"
//                     ? 28
//                     : 24),
//             labelText: label,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(width: 1, color: Colors.black),
//             )));
//   }
// }
