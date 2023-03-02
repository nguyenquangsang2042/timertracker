import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker/app/home/model/Job.dart';
import 'package:timer_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:timer_tracker/services/database.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key, required this.database});

  final Database database;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => AddJobPage(
                database: database,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        return true;
      }
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final job = Job(name: _name!, ratePerHour: _ratePerHour!);
        await widget.database.createJob(job);
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context, title: "Operation failed", exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: const Text("New job"),
        actions: [
          TextButton(
              onPressed: () => _submit(),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    final _jobNameNodeFocus= FocusNode();
    final _ratePerHourNodeFocus=FocusNode();
    return [
      TextFormField(
        focusNode: _jobNameNodeFocus,
        decoration: const InputDecoration(labelText: "Job name"),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value){FocusScope.of(context).requestFocus(_ratePerHourNodeFocus);},

      ),
      TextFormField(
        textInputAction: TextInputAction.done,
        focusNode: _ratePerHourNodeFocus,
        onSaved: (value) => _ratePerHour = int.parse(value!) ?? 0,
        decoration: const InputDecoration(labelText: "Rate per hour"),
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
      ),
    ];
  }
}
