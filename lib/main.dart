import 'package:flutter/material.dart';
import 'model/form.dart';
import 'controller/form_controller.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Sheet Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          key: UniqueKey(), // Provide a unique key.
          title: 'Send Data To Google Sheets'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FeedbackForm feedbackForm = FeedbackForm(
        nameController.text,
        emailController.text,
        mobileNoController.text,
        feedbackController.text,
      );

      FormController formController = FormController();

      formController.submitForm(feedbackForm, (String response) {
        print("Response: $response");
        if (response == FormController.status_success) {
          _showSnackbar("Feedback Submitted");
        } else {
          _showSnackbar("Error Occurred!");
        }
      });
    }
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Valid Name';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (!value!.contains("@")) {
                    return 'Enter Valid Email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              TextFormField(
                controller: mobileNoController,
                validator: (value) {
                  if (value!.trim().length != 10) {
                    return 'Enter 10 Digit Mobile Number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Mobile Number'),
              ),
              TextFormField(
                controller: feedbackController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Valid Feedback';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(hintText: 'Feedback'),
              ),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                  _showSnackbar("Submitting Feedback");
                },
                child: const Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
