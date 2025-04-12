import '/bloc/data_base_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'AppBar.dart';
import 'SignIn.dart';
import 'Widgets.dart';

class SignUp extends StatefulWidget {
  static const Route = '/SignUp';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String Username, Email, Password, UserType = "Male";
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    double Hight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar('Sign Up'),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: Image.asset(
              "assets/images/background_top.png",
              width: double.infinity,
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            height: Hight,
            child: Image.asset(
              "assets/images/background_bottom.png",
              width: double.infinity,
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 30),
            Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 150),
                child: Form(
                    key: formstate,
                    child: Column(children: [
                      TextFormFieldMethod(
                          "Username",
                          "Username can't to be larger than 100 letter",
                          "Username can't to be less than 2 letter",
                          Icons.account_circle,
                          "Username"),
                      SizedBox(height: 15),
                      TextFormFieldMethod(
                          "Email",
                          "Email can't to be larger than 100 letter",
                          "Email can't to be less than 2 letter",
                          Icons.email,
                          "Email"),
                      SizedBox(height: 15),
                      TextFormFieldMethod(
                          "Password",
                          "Password can't to be larger than 100 letter",
                          "Password can't to be less than 4 letter",
                          Icons.article,
                          "Password"),
                      SizedBox(height: 15),
                      UserTypeMethod(width),
                      SizedBox(height: 10),
                      GoToSignMethod(
                          context, "you hava an account ? ", SignIn.Route),
                      SizedBox(height: 10),
                      InkWell(
                        child: SignButtonMethod("Sign Up"),
                        onTap: () async {
                          var formdata = formstate.currentState;
                          if (formdata!.validate()) {
                            formdata.save();
                         
                            BlocProvider.of<DataBaseBloc>(context).add(
                                SignUpEvent(
                                    Username: Username.toString(),
                                    Email: Email.toString(),
                                    Password: Password.toString(),
                                    UserType: UserType.toString(),
                                    context: context));
                          } else {}
                        },
                      )
                    ])))
          ]),
        ],
      )),
    );
  }

  Container UserTypeMethod(double width) {
    List<String> list = ["Male", "Female"];
    return Container(
      width: width - 40,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(
            UserType == "Male" ? Icons.male : Icons.female,
            size: 30,
            color: Colors.orange,
          ),
          SizedBox(width: 10),
          DropdownButton<String>(
            value: UserType,
            onChanged: (Object? value) {
              setState(() {
                UserType = value.toString();
                //clinics_type = list.indexOf(value.toString());
              });
            },
            selectedItemBuilder: (BuildContext context) {
              return list.map<Widget>((String item) {
                return Container(
                    alignment: Alignment.center,
                    //  color: Colors.amber,
                    width: width - 126,
                    child: Text(item, textAlign: TextAlign.start));
              }).toList();
            },
            items: list.map((String item) {
              return DropdownMenuItem<String>(
                alignment: Alignment.center,
                child: Text(item),
                value: item,
              );
            }).toList(),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(width: 1, color: Colors.black.withOpacity(0.4))
          // borderSide: BorderSide(width: 1),
          ),
    );
  }

  TextFormField TextFormFieldMethod(
    //TextEditingController value,
    String value,
    String validator1,
    String validator2,
    IconData icon,
    String label,
  ) {
    return TextFormField(
      //controller: value,
      style: TextStyle(color: Colors.black),

      onChanged: (String val) {
        if (value == "Email") {
          Email = val;
        }
        if (value == "Password") {
          Password = val;
        }
        if (value == "Username") {
          Username = val;
        }
      },
      validator: (val) {
        if (val!.length > 100) {
          return validator1;
        }
        if (val.length < 2) {
          return validator2;
        }
        return null;
      },
      //  obscureText: true,

      decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.orange,
            size: label == "ClinicPlace" || label == "ClinicPlace_inEnglish"
                ? 28
                : 24,
          ),
          // hintText: "Write Your Email".tr(),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(width: 1, color: Colors.black),
          )),
    );
  }

  Padding dropDownMethod(
      double screenWidth, String initValue, List<String> list) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          DropdownButton<String>(
            value: initValue,
            hint: Container(
              alignment: Alignment.centerRight,
              width: 180,
            ),
            onChanged: (Object? value) {},
            selectedItemBuilder: (BuildContext context) {
              return list.map<Widget>((String item) {
                return Container(
                    alignment: Alignment.center,
                    width: screenWidth / 2,
                    child: Text(item, textAlign: TextAlign.end));
              }).toList();
            },
            items: list.map((String item) {
              return DropdownMenuItem<String>(
                alignment: Alignment.topRight,
                child: Text(item),
                value: item,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
