import 'package:call/provider/Contact%20Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Map/googleMap_implement.dart';
import 'Notification/FirebaseNotification.dart';
import 'Notification/getBy number.dart';
import 'contact.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime lastTimeBackbuttonWasClicked =DateTime.now();
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<ContactsProvider>(context);
    final FirebaseController firebaseController = Get.find();

    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(lastTimeBackbuttonWasClicked) >=
            Duration(seconds: 1)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Press the back button again to go back"),
              duration: Duration(seconds: 2),
            ),
          );
          lastTimeBackbuttonWasClicked = DateTime.now();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: ListView.builder(
          itemCount: contactsProvider.selectedContacts.length,
          itemBuilder: (context, index) {
            Contact contact = contactsProvider.selectedContacts[index] as Contact;
            return ListTile(
              title: Text(contact.displayName!),
              trailing: IconButton(
                onPressed: () {
                  String phoneNumber = contact.phones!.isNotEmpty
                      ? contact.phones!.first.number
                      : 'No phone number available';
                  phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => gstbyPhoneNumber(phoneNumber: phoneNumber),
                    ),
                  );
                },
                icon: Icon(Icons.location_on_outlined),
              ),
              onTap: () {
                String phoneNumber = contact.phones!.isNotEmpty
                    ? contact.phones!.first.number
                    : 'No phone number available';
                phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), ''); // Remove non-digit characters

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(contact.displayName!),
                    content: Text(phoneNumber.isNotEmpty
                        ? phoneNumber
                        : 'No phone number available'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );

                print(phoneNumber); // Print the phone number
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final selectedContact = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactPage()),
            );
            if (selectedContact != null) {
              contactsProvider.addContact(selectedContact);
              setState(() {
                phoneNumber = selectedContact.phones.isNotEmpty ? selectedContact.phones.first.number : '';
              });
              print('Selected phone number: $phoneNumber');
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
