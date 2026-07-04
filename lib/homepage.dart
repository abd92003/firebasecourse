// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecourse/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<QueryDocumentSnapshot> data = [];

  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
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
          Navigator.of(context).pushNamed("addcategory");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Homepage'),
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
      body: isLoading == true
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
                    AppDialogs.showDeleteDialog(
                      context: context,
                      title: 'Delete Category',
                      message:
                          'Are you sure you want to delete "${data[i]['name']}"?\nThis action cannot be undone.',
                      onDelete: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection("categories")
                              .doc(data[i].id)
                              .delete();
                          data.removeAt(i);
                          setState(() {});
                          AppDialogs.success(
                            context,
                            'Category deleted successfully!',
                          );
                        } catch (e) {
                          AppDialogs.error(
                            context,
                            'Failed to delete: ${e.toString()}',
                          );
                        }
                      },
                    );
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset("images/folder.png", height: 100),
                          Text("${data[i]['name']}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
