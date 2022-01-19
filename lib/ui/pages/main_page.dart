import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_todoapp/ui/widgets/widgets.dart';
import '../../shared/theme.dart';

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key? key, required this.title}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference db = firestore.collection('todolist');
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    bool isUpdate = false;
    String updateId;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
            // Order List by item created
            stream: db.orderBy('timeCreated').snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.docs
                      .map(
                        (e) => CustomListTile((e.data() as dynamic)['title'],
                            (e.data() as dynamic)['description'], onUpdate: () {
                          titleController.text = (e.data() as dynamic)['title'];
                          descController.text =
                              (e.data() as dynamic)['description'].toString();
                          updateId = e.id;
                          isUpdate = true;
                          showModalBottomSheet(
                              context: context,
                              elevation: 5,
                              isScrollControlled: true,
                              builder: (_) => Container(
                                    padding: EdgeInsets.only(
                                      top: 15,
                                      left: 15,
                                      right: 15,
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          120,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration: const InputDecoration(
                                              hintText: 'Title'),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          controller: descController,
                                          decoration: const InputDecoration(
                                              hintText: 'Description'),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                titleController.text = '';
                                                descController.text = '';
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //// UPDATE DATA HERE
                                                db.doc(updateId).update({
                                                  'title': titleController.text,
                                                  'description':
                                                      descController.text,
                                                  'lastEdited': DateTime.now()
                                                });

                                                //// CLOSE MODAL
                                                Navigator.of(context).pop();
                                                titleController.text = '';
                                                descController.text = '';
                                              },
                                              child: Text('Update Data'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                        }, onDelete: () {
                          db.doc(e.id).delete();
                        }),
                      )
                      .toList(),
                );
              } else {
                return Text("Loading...");
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              elevation: 5,
              isScrollControlled: true,
              builder: (_) => Container(
                    padding: EdgeInsets.only(
                      top: 15,
                      left: 15,
                      right: 15,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 120,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(hintText: 'Title'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: descController,
                          decoration:
                              const InputDecoration(hintText: 'Description'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                titleController.text = '';
                                descController.text = '';
                              },
                              child: Text('Cancel'),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //// ADD DATA HERE
                                db.add({
                                  'title': titleController.text,
                                  'description': descController.text,
                                  'timeCreated': DateTime.now(),
                                  'lastEdited': DateTime.now()
                                });

                                //// CLOSE MODAL
                                Navigator.of(context).pop();
                                titleController.text = '';
                                descController.text = '';
                              },
                              child: Text('Create New'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
        },
        tooltip: 'Add list',
        child: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
