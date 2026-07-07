// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../note/add.dart';
import '../note/edit.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NoteView extends StatefulWidget {
  final String categoryid;
  const NoteView({super.key, required this.categoryid});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List<QueryDocumentSnapshot> data = [];

  bool isLoading = true;

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("note")
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(docid: widget.categoryid),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("login", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: WillPopScope(
        child: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                itemCount: data.length, // 3
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 160,
                ),
                itemBuilder: (context, i) {
                  return InkWell(
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: "هل انت متاكد من عملية الحذف",
                        btnCancelOnPress: () async {},
                        btnOkOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection("categories")
                              .doc(widget.categoryid)
                              .collection("note")
                              .doc(data[i].id)
                              .delete();
                              if (data[i]['url'] != "none") {
                                await FirebaseStorage.instance.refFromURL(data[i]['url']).delete();
                              }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteView(categoryid: widget.categoryid),
                            ),
                          );
                        },
                      ).show();
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditNote(
                            notedocid: data[i].id,
                            categorydocid: widget.categoryid,
                            value: data[i]['note'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(children: [
                          Text("${data[i]['note']}"),
                          SizedBox(height: 10),
                          if (data[i]['url'] != "none") Image.network("${data[i]['url']}", height: 80, fit: BoxFit.cover),
                          
                        ]),
                      ),
                    ),
                  );
                },
              ),
        onWillPop: () {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("homepage", (route) => false);
          return Future.value(false);
        },
      ),
    );
  }
}
