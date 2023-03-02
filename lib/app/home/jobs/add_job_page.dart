import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker/app/home/model/Job.dart';
import 'package:timer_tracker/services/database.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key,required this.database});
  final Database database;

  static Future<void> show(BuildContext context) async {
    final database=Provider.of<Database>(context,listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => AddJobPage(database: database,), fullscreenDialog: true),
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

  Future<void> _submit()async {
    if (_validateAndSaveForm()) {
      final job=Job(name: _name!, ratePerHour: _ratePerHour!);
      await widget.database.createJob(job);
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
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: "Job name"),
        validator: (value)=>value!.isNotEmpty?null:'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        onSaved: (value) => _ratePerHour = int.parse(value!) ?? 0,

        decoration: const InputDecoration(labelText: "Rate per hour"),
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: false),
      )
    ];
  }
}
