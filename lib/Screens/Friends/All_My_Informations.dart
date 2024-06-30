// ignore_for_file: public_member_api_docs, sort_constructors_first
import '/Auth_And_Tools/Values.dart';
import '/Screens/Drawer/Set_Profile_Image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Auth_And_Tools/Models.dart';
import '/bloc/data_base_bloc.dart';

// ignore: must_be_immutable
class AllMyInformations extends StatefulWidget {
  UsersInformationModel MyInfo;
  AllMyInformations({required this.MyInfo});

  @override
  State<AllMyInformations> createState() => _AllMyInformationsState();
}

class _AllMyInformationsState extends State<AllMyInformations> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  var Status, MyEmail, Firstname, Lastname, Date_of_Birth, Interested_in;
  var Look_For, Eye_Color, Hair_Color, Height, Relationship, City, Age, Gender;
  DateTime date = DateTime(2022, 12, 24);

  @override
  void initState() {
    MyEmail = widget.MyInfo.Email;
    Status = widget.MyInfo.Status;
    Firstname = widget.MyInfo.Firstname;
    Lastname = widget.MyInfo.Lastname;
    Gender = widget.MyInfo.Gender;
    Date_of_Birth = widget.MyInfo.Birth_Date;
    Interested_in = widget.MyInfo.Interested_in;
    Look_For = widget.MyInfo.Look_For;
    Eye_Color = widget.MyInfo.Eye_Color;
    Hair_Color = widget.MyInfo.Hair_Color;
    Height = widget.MyInfo.Height;
    Relationship = widget.MyInfo.Relationship;
    City = widget.MyInfo.City;
    Age = widget.MyInfo.Age;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthImage = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
            title: Text("Edit Profile",
                style: TextStyle(
                    color: titleRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            actions: [
              IconButton(
                  onPressed: () async {
                    BlocProvider.of<DataBaseBloc>(context).add(
                        UpdateMyInfomationEvent(
                            Email: MyEmail,
                            Status: Status,
                            Firstname: Firstname,
                            Lastname: Lastname,
                            Gender: Gender,
                            Date_of_Birth: Date_of_Birth,
                            Interested_in: Interested_in,
                            Look_For: Look_For,
                            Eye_Color: Eye_Color,
                            Hair_Color: Hair_Color,
                            Height: Height,
                            Relationship: Relationship,
                            City: City,
                            Age: Age.toString(),
                            UserId: widget.MyInfo.UserId));
                    Navigator.of(context)
                        .pushReplacementNamed(SetProfileImage.Route);
                  },
                  icon: Icon(Icons.done))
            ]),
        body: ListView(children: [
          Form(
              key: formstate,
              child: Column(children: [
                titleMethod("Status"),
                subTitleMethod("Update your status"),
                LabelMethod("Status", Icons.note),
                titleMethod("Basic Informayion"),
                subTitleMethod("Firstname Lastname"),
                LabelMethod("Firstname", Icons.note),
                LabelMethod("Lastname", Icons.note)
              ])),
          genderMethod(widthImage),
          titleMethod("Other Information"),
          towDropdowndownMethod(
              widthImage,
              "Interest in",
              ["N/A", "Women", "men", "Both"],
              "Looking For",
              [
                "N/A",
                "Friendship",
                "Dating",
                "Serious Relationship",
                "Networking"
              ],
              Interested_in,
              Look_For,
              Icons.person_add),
          towDropdowndownMethod(
              widthImage,
              "Eye Color",
              ["N/A", "Blue", "Brown", "Gray", "Green", "Black"],
              "Hair Color",
              [
                "N/A",
                "Blonde",
                "Dark Blonde",
                "Light Brown",
                "Gray",
                "Silver",
                "Red",
                "Black"
              ],
              Eye_Color,
              Hair_Color,
              Icons.palette),
          towDropdowndownMethod(
              widthImage,
              "Height",
              ["N/A", "4.6(137cm)", "4.10(147cm)"],
              "Relationship",
              ["N/A", "single", "in a Relationship", "Married", "Divorced"],
              Height,
              Relationship,
              Icons.group),
          countryMethod(widthImage),
        ]));
  }

  Container subTitleMethod(String command) {
    return Container(
        height: 40,
        child: Row(children: [
          SizedBox(width: 30),
          Text(command, style: TextStyle(fontSize: 17, color: Colors.black))
        ]));
  }

  Row genderMethod(double widthImage) {
    return Row(children: [
      Container(width: widthImage / 7, child: Icon(Icons.account_circle)),
      Container(
          width: 3 * widthImage / 7,
          child: Column(children: [
            Container(
                width: 3 * widthImage / 7,
                child: Text("Gender", style: TextStyle(fontSize: 17))),
            Container(
              width: 3 * widthImage / 7,
              child: DropdownButton(
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  items: ["Male", "Female"]
                      .map((e) => DropdownMenuItem(
                            child: Text("$e"),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (Object? value) {
                    setState(() {
                      Gender = value.toString();
                      print(Gender);
                    });
                  },
                  value: Gender),
            )
          ])),
      Container(
          width: 3 * widthImage / 7 - 25,
          child: Column(children: [
            Container(
                width: 3 * widthImage / 7,
                child: Text(
                  "Birth Date",
                  style: TextStyle(fontSize: 17),
                )),
            InkWell(
                child: Row(children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100));
                        if (newDate == null) return;
                        setState(() {
                          date = newDate as DateTime;
                          Date_of_Birth =
                              "${date.year}/${date.month}/${date.day}";
                          DateTime birthDate =
                              DateTime(date.year, date.month, date.day);
                          Age = DateTime.now().difference(birthDate).inDays ~/
                              365;
                        });
                      },
                      child: Text(Date_of_Birth))),
              Icon(Icons.calendar_today)
            ]))
          ]))
    ]);
  }

  Row towDropdowndownMethod(double widthImage, String title1, List list1,
      String title2, List list2, var select1, var select2, IconData myicon) {
    return Row(children: [
      Container(width: widthImage / 7, child: Icon(myicon)),
      Container(
          width: 3 * widthImage / 7,
          child: Column(children: [
            Container(
                width: 3 * widthImage / 7,
                child: Text(title1, style: TextStyle(fontSize: 17))),
            Container(
              width: 3 * widthImage / 7,
              child: DropdownButton(
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  items: list1
                      .map((e) => DropdownMenuItem(
                            child: Text("$e"),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (Object? value) {
                    setState(() {
                      select1 = value.toString();
                      if (title1 == "Interest in") {
                        Interested_in = select1;
                      } else if (title1 == "Eye Color") {
                        Eye_Color = select1;
                      } else if (title1 == "Height") {
                        Height = select1;
                      }
                    });
                  },
                  value: select1),
            )
          ])),
      Container(
          width: 3 * widthImage / 7 - 25,
          child: Column(children: [
            Container(
                width: 3 * widthImage / 7,
                child: Text(
                  title2,
                  style: TextStyle(fontSize: 17),
                )),
            Container(
              width: 3 * widthImage / 7,
              child: DropdownButton(
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  items: list2
                      .map((e) => DropdownMenuItem(
                            child: Text("$e"),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (Object? value) {
                    setState(() {
                      select2 = value.toString();
                      if (title2 == "Looking For") {
                        Look_For = select2;
                      } else if (title2 == "Hair Color") {
                        Hair_Color = select2;
                      } else if (title2 == "Relationship") {
                        Relationship = select2;
                      }
                    });
                  },
                  value: select2),
            )
          ]))
    ]);
  }

  Container titleMethod(String title) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 40,
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(fontSize: 15, color: Colors.red),
      ),
    );
  }

  Column LabelMethod(String label, IconData icon) {
    return Column(children: [
      Container(
          child: TextFormField(
              initialValue: label == "Status"
                  ? Status
                  : (label == "Firstname" ? Firstname : Lastname),
              validator: (val) {
                if (val!.length > 255) {
                  return "Notes can't to be larger than 255 letter";
                }
                if (val.length < 10) {
                  return "Notes can't to be less than 10 letter";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  if (label == "Status") {
                    Status = value;
                  } else if (label == "Firstname") {
                    Firstname = value;
                  } else if (label == "Lastname") {
                    Lastname = value;
                  }
                });
              },
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: label,
                  prefixIcon: Icon(icon))))
    ]);
  }

  Row countryMethod(double widthImage) {
    return Row(children: [
      Container(width: widthImage / 7, child: Icon(Icons.home)),
      Container(
          width: 6 * widthImage / 7,
          child: Column(children: [
            Container(
                width: 6 * widthImage / 7,
                child: Text("City", style: TextStyle(fontSize: 17))),
            Container(
              width: 6 * widthImage / 7,
              child: DropdownButton(
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  items: ["Aleppo", "Damascus", "Latakia"]
                      .map((e) => DropdownMenuItem(
                            child: Text("$e"),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (Object? value) {
                    setState(() {
                      City = value.toString();
                    });
                  },
                  value: City),
            )
          ]))
    ]);
  }
}
