import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker/app/home/model/Job.dart';
import 'package:timer_tracker/common_widgets/show_alert_dialog.dart';
import 'package:timer_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:timer_tracker/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({super.key, required this.database, this.job});

  final Job? job;

  final Database database;

  static Future<void> show(BuildContext context, {Job? job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditJobPage(
                database: database,
                job: job,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

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
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(context,
              title: "Name already used",
              content: "Please choice a different job name",
              defaultActionText: "OK",
              allowBarrierDismissible: true);
        } else if (_name == null || _ratePerHour == null || _name!.isEmpty) {
          showAlertDialog(context,
              title: "Some value empty",
              content: "Some field empty. Please type it",
              defaultActionText: "OK",
              allowBarrierDismissible: true);
        } else {
          final id = widget.job?.id ?? documentIDFromCurrentDate();
          final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: "Operation failed", exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? "New job" : "Edit job"),
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
    final _jobNameNodeFocus = FocusNode();
    final _ratePerHourNodeFocus = FocusNode();
    return [
      TextFormField(
        focusNode: _jobNameNodeFocus,
        decoration: const InputDecoration(labelText: "Job name"),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
        initialValue: _name,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(_ratePerHourNodeFocus);
        },
      ),
      TextFormField(
        textInputAction: TextInputAction.done,
        focusNode: _ratePerHourNodeFocus,
        initialValue: _ratePerHour != null ? '$_ratePerHour' : '',
        onSaved: (value) => _ratePerHour =
            (value == null || value.isEmpty) ? 0 : int.tryParse(value),
        decoration: const InputDecoration(labelText: "Rate per hour"),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
      ),
    ];
  }
}
