import 'package:flutter/material.dart';
import 'package:ft_hangouts/main.dart';
import 'package:ft_hangouts/utils/database_controller.dart';
import 'package:ft_hangouts/models/contact.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:ft_hangouts/utils/utils.dart';


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
  String imagePath = 'assets/images/avatar/profile-placeholder.jpg';
  String? base64image;
  File? imagePicked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Text(AppLocalizations.of(context)!.createNewContact),
      ),
      body:
        Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
          physics: BouncingScrollPhysics(),
          child: Column(children:[
            imagePicked != null
                    ? CircleAvatar(
                        radius: 80,
                        backgroundColor: globalColor.value.shade900,
                        child: CircleAvatar(
                          backgroundImage: 
                              imageHelper.imageFromBase64String(base64image!).image,
                          radius:75)):
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: globalColor.value.shade900,
                          child : CircleAvatar(
                          radius: 75,
                          backgroundImage: Image.asset('assets/images/avatar/profile-placeholder.jpg').image,
                        )),
            const SizedBox(height:5),
            imagePicked == null ?
            SizedBox(
              width:160,
              height:30,
              child: ElevatedButton(
                onPressed: () async {
                  File? croppedImage = await imageHelper.uploadImage();
                  if (croppedImage != null) {
                    setState(() {
                      imagePicked = croppedImage;
                      base64image = imageHelper.base64String(imagePicked!.readAsBytesSync());
                    });
                  }
                },
                child: Text(AppLocalizations.of(context)!.addPicture),
             ),
            ) : 
            SizedBox(
              width:180,
              height:30,
              child: Row(children: [
                SizedBox(
                  width:135,
                  height:30,
                  child: ElevatedButton(
                   onPressed: () async {
                     File? croppedImage = await imageHelper.uploadImage();
                     if (croppedImage != null) {
                       setState(() {
                         imagePicked = croppedImage;
                         base64image = imageHelper.base64String(imagePicked!.readAsBytesSync());
                       });
                     }
                   },
                   child: Text(AppLocalizations.of(context)!.addPicture),
                   ),  
                ),
                SizedBox(width:10),
                SizedBox(
                  width:35,
                  height:30,
                  child: Ink(
                    decoration: ShapeDecoration(
                      color: globalColor.value.shade900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    ),
                    child: IconButton(
                       padding: const EdgeInsets.all(4.0),
                       onPressed: () async {
                          setState(() {
                            imagePicked = null;
                          });
                      },
                      color: Colors.white,
                      icon: Icon(Icons.delete),
                    )
                  )
                ),
             ]),
             
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: firstNameController,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return AppLocalizations.of(context)!.firstNameEmpty;
                return null;
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.firstName,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: lastNameController,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return AppLocalizations.of(context)!.lastNameEmpty;
                return null;
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.lastName,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: phoneNumberController,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !RegExp(r"^0\d{9}$").hasMatch(value))
                  return AppLocalizations.of(context)!.phoneNumberFormat;
                return null;
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.phoneNumber,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Contact updatedContact = Contact(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      phoneNumber: phoneNumberController.text,
                      profilePicture: base64image != null ? base64image : await imageHelper.base64placeHolder()
                    );
                    databaseController.instance
                        .insertContact(updatedContact)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(AppLocalizations.of(context)!.createDone)),
                      );
                      widget.updater.value = !widget.updater.value;
                      Navigator.pop(context, true);
                    });
                  }
                },
                child: Text(AppLocalizations.of(context)!.createContact)),
          ],
        ),
      ),),
    );
  }
}

// ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Processing Data')),
//                   );
