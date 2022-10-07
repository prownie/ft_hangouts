import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangouts/database_controller.dart';
import 'package:ft_hangouts/models/contact.dart';

class contactPage extends StatefulWidget {
  final ValueNotifier<bool> updater;
  final String contactId;

  contactPage(this.contactId, this.updater);

  @override
  State<contactPage> createState() => contactPageState();
}

class contactPageState extends State<contactPage> {
  Contact? _contact;
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void initState() {
    databaseController.instance
        .getContactFromId(widget.contactId!)
        .then((value) {
      setState(() {
        _contact = new Contact(
            id: value[0]['id'],
            firstName: value[0]['firstName'],
            lastName: value[0]['lastName'],
            phoneNumber: value[0]['phoneNumber']);
        firstNameController.text = _contact!.firstName!;
        lastNameController.text = _contact!.lastName!;
        phoneNumberController.text = _contact!.phoneNumber!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_contact != null) {
      return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, true),
            ),
            title: Text(_contact!.firstName! + ' ' + _contact!.lastName!)),
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
                    hintText: _contact!.firstName!),
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
                    hintText: _contact!.lastName!),
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
                    hintText: _contact!.phoneNumber!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Contact updatedContact = Contact(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          phoneNumber: phoneNumberController.text,
                          id: _contact?.id);
                      databaseController.instance
                          .updateContact(updatedContact)
                          .then((value) {
                        initState();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Update done')),
                        );
                      });
                    }
                  },
                  child: const Text('Save changes')),
              ElevatedButton(
                child: const Text('Delete contacts'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        color: Color.fromARGB(255, 193, 193, 193),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                  child: const Text('No'),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              ElevatedButton(
                                  child: const Text('Yes'),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    databaseController.instance
                                        .deleteContact(_contact!)
                                        .then((value) {
                                      widget.updater.value =
                                          !widget.updater.value;
                                      int count = 0;
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 2;
                                      });
                                    });
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      );
    }
    return Scaffold();
  }
}

// ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Processing Data')),
//                   );
