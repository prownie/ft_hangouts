import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangouts/database_controller.dart';
import 'package:ft_hangouts/models/contact.dart';

class createContact extends StatefulWidget {
  final ValueNotifier<bool> updater;

  createContact(this.updater);

  @override
  State<createContact> createState() => createContactState();
}

class createContactState extends State<createContact> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text('Create new contact'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            TextFormField(
              controller: firstNameController,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "First name can't be empty";
                return null;
              },
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: lastNameController,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "Last name can't be empty";
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: phoneNumberController,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !RegExp(r"^0\d{9}$").hasMatch(value))
                  return "Bad phone number format. Must start with 0, followed by 9 digits";
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Contact updatedContact = Contact(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      phoneNumber: phoneNumberController.text,
                    );
                    databaseController.instance
                        .insertContact(updatedContact)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('New contact created')),
                      );
                      widget.updater.value = !widget.updater.value;
                      Navigator.pop(context, true);
                    });
                  }
                },
                child: const Text('Create contact')),
          ],
        ),
      ),
    );
  }
}

// ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Processing Data')),
//                   );
