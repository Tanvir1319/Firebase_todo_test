import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firbase_test/auth/login_screen.dart';
import 'package:todo_firbase_test/models/note_model.dart';

import 'package:todo_firbase_test/repositories/firebase_notes_repository.dart';
import 'package:todo_firbase_test/widgets/RestAPIPages/Screens/restapi_show.dart';
import 'package:todo_firbase_test/widgets/button.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? paymentIntent;
  final TextEditingController _titleTextEditingController =
      TextEditingController();

  final TextEditingController _noteBodyTextEditingController =
      TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  //stripe intregation
  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10000', 'GBP');

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Abhi',
                  googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'sk_test_51Mm3YzSENe3l8TPlWEc6LrzPzC4KZOP5TvMB1DSCLgAMIAIXXfn6Sd82IwlC3dWuz6tBc91DDsAJn1GvShjur1p1005xkZUqko',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  //alert dialog
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget NoButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget YesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        signOut();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert!"),
      content: Text("Do you Want to Logout?"),
      actions: [
        NoButton,
        YesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-do App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showAlertDialog(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              leading: Icon(
                Icons.api,
              ),
              title: const Text('Rest API Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestapiShow()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.close,
              ),
              title: const Text('Close'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.money,
              ),
              title: const Text('Donate Us'),
              onTap: () async {
                await makePayment();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                height: 600.0,
                child: Column(
                  children: [
                    const Text("Write a note",
                        style: TextStyle(fontSize: 40.0)),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: _titleTextEditingController,
                      decoration: const InputDecoration(
                        hintText: "Tite of the note",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SingleChildScrollView(
                      child: TextField(
                        controller: _noteBodyTextEditingController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: "Note Text",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                        child: Text("Save Note"),
                        onPressed: () {
                          FirebaseNoteRepository.saveNote(
                            NoteModel(
                                id: "00",
                                title: _titleTextEditingController.text,
                                text: _noteBodyTextEditingController.text),
                          );

                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseNoteRepository.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error Loading Data"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, int index) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data?[index].title ?? 'Not title',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          snapshot.data?[index].text ?? "No Text",
                          style: TextStyle(fontSize: 11.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _titleTextEditingController.text =
                                snapshot.data?[index].title ?? "No Title";
                            _noteBodyTextEditingController.text =
                                snapshot.data?[index].text ?? "No Text";
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  height: 600.0,
                                  child: Column(
                                    children: [
                                      const Text("Edit Note",
                                          style: TextStyle(fontSize: 40.0)),
                                      const SizedBox(height: 12.0),
                                      TextField(
                                        controller: _titleTextEditingController,
                                        decoration: const InputDecoration(
                                          hintText: "Tite of the note",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      TextField(
                                        controller:
                                            _noteBodyTextEditingController,
                                        maxLines: 5,
                                        decoration: const InputDecoration(
                                          hintText: "Note Text",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      ElevatedButton(
                                          child: Text("Save Changes"),
                                          onPressed: () {
                                            FirebaseNoteRepository.updateNote(
                                              NoteModel(
                                                  id: snapshot.data![index].id,
                                                  title:
                                                      _titleTextEditingController
                                                          .text,
                                                  text:
                                                      _noteBodyTextEditingController
                                                          .text),
                                            );
                                            Navigator.of(context).pop();
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => FirebaseNoteRepository.deleteNote(
                              snapshot.data![index]),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
