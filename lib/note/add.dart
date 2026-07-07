import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../components/custombuttonauth.dart';
import '../components/customtextfieldadd.dart';
import '../note/view.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  File? file;
  String? url;
  bool isLoading = false;

  Future<void> addNote(BuildContext context) async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.docid)
        .collection("note");

    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});

        await collectionnote.add({"note": note.text, "url": url ?? "none"});

        isLoading = false;
        setState(() {});

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NoteView(categoryid: widget.docid),
            ),
          );
        }
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("Error: $e");
        if (mounted) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Failed to add note: $e',
            btnOkOnPress: () {},
          ).show();
        }
      }
    }
  }

  // ✅ دالة الكاميرا
  Future<void> getImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? imagecamera = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (imagecamera != null) {
        file = File(imagecamera.path);
        setState(() {});

        // ✅ رفع الصورة مع تحميل
        AwesomeDialog(
          context: context as BuildContext,
          dialogType: DialogType.info,
          animType: AnimType.scale,
          title: 'Uploading',
          desc: 'Uploading image...',
          btnOkOnPress: () {},
        ).show();

        var imagename = basename(imagecamera.path);
        var refStorage = FirebaseStorage.instance
            .ref("images")
            .child("${DateTime.now().millisecondsSinceEpoch}_$imagename");

        await refStorage.putFile(file!);
        url = await refStorage.getDownloadURL();

        // ✅ إخفاء التحميل
        Navigator.pop(context as BuildContext);

        // ✅ رسالة نجاح
        AwesomeDialog(
          context: context as BuildContext,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Success',
          desc: 'Image uploaded successfully!',
          btnOkOnPress: () {},
        ).show();

        setState(() {});
      }
    } catch (e) {
      // ✅ رسالة خطأ
      AwesomeDialog(
        context: context as BuildContext,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Failed to take photo: $e',
        btnOkOnPress: () {},
      ).show();
      print("Camera error: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Note")),
      body: Form(
        key: formState,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    CustomTextFormAdd(
                      hinttext: "Enter Your Note",
                      mycontroller: note,
                      validator: (val) {
                        if (val == "") {
                          return "Can't be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    // ✅ عرض الصورة الملتقطة
                    if (file != null)
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(file!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: getImage,
                      icon: Icon(Icons.camera_alt),
                      label: Text(
                        url == null ? 'Take Photo' : '📸 Change Photo',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),

                    SizedBox(height: 20),

                    CustomButtonAuth(
                      title: "Add",
                      onPressed: () {
                        addNote(context);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
