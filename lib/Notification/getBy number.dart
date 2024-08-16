import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'FirebaseNotification.dart';
import 'GetByPhoneModel.dart';
import 'model.dart';

class gstbyPhoneNumber extends StatefulWidget {
  final String phoneNumber;
  //final String withoutCoutryCodePhoneNumber;
  const gstbyPhoneNumber({super.key, required this.phoneNumber});

  @override
  State<gstbyPhoneNumber> createState() => _gstbyPhoneNumberState();
}

class _gstbyPhoneNumberState extends State<gstbyPhoneNumber> {

  final FirebaseController dataController = Get.put(FirebaseController());
  final FirebaseController nullPhone = Get.find();

  Future<getByPhone> fetch() async {
    final String phoneNumber = widget.phoneNumber;
    final String Verify=phoneNumber;
    final String Verify2=nullPhone.withoutCoutryCodePhoneNumber .toString();
    print(Verify);
    print(Verify2);

    var res = await http.get(Uri.parse("http://node.amoseraja.tech/api/getByPhone/$phoneNumber"));
    //var res2=await http.get(Uri.parse("http://node.amoseraja.tech/api/getByPhone/$Verify2"));

    if (res.statusCode == 200) {
      return getByPhone.fromJson(jsonDecode(res.body));
    }
    else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Contact'),
      ),
      body: Column(
        children: [
          FutureBuilder<getByPhone>(
            future: fetch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Column(
                  children: [
                    SizedBox( height:50 ,child: Center(child: Text("Your contact should be save in the format of country code and number"))),
                    SizedBox(height:30 ,child: Center(child: Text("Example : +91 xxxxxxxxxx",style: TextStyle(color: Colors.red),))),
                    SizedBox(height:30 ,child: Text("or")),
                    SizedBox(height:30 ,child: Text("The person didn't installed this App")),
                    SizedBox(height:30 ,child: Text("or")),
                    SizedBox(height:30 ,child: Text('Error: ${snapshot.error}')),
                  ],
                ));
              } else if (snapshot.hasData) {
                Data? data = snapshot.data!.data;
                if (data != null) {
                  // final String? _id=data.sId;
                  // final String? Token=data.token;

                  dataController.setData(
                    data.sId,
                    data.token,
                    data.name,
                    data.emailId,
                  );
                  //dataController.setData(id, token, name, emailId)
                  print(data.name);
                  print(data.phone);
                  print(data.token);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      borderOnForeground: true,
                      color: Colors.grey,
                      elevation: 20.0,
                      shadowColor: Colors.grey,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${data.name}'),
                            Text('Phone: ${data.phone}'),
                            Text('Email: ${data.emailId}'),
                            // Text("ID:${data.sId}"),
                            Center(
                              child: ElevatedButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Notify()));
                              }, child: Text("map")),
                            )
                          ],

                        ),

                      ),

                    ),
                  );



                } else {
                  return Center(child: Text('No data found'));
                }
              } else {
                return Center(child: Text('No data found'));
              }
            },

          ),
        ],
      ),
    );
  }
}
