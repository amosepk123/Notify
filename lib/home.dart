
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';
import 'Map/googleMap_implement.dart';
import 'provider/Contact Provider.dart';
import 'contact.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<ContactsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: contactsProvider.selectedContacts.length,
        itemBuilder: (context, index) {
          Contact contact = contactsProvider.selectedContacts[index] as Contact;
          return ListTile(
            title: Text(contact.displayName!),
            trailing: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GGGG()));
            },icon: Icon(Icons.location_on_outlined),),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(contact.displayName!),
                  content: Text(contact.phones!.isNotEmpty
                      ? contact.phones!.first.number
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
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}