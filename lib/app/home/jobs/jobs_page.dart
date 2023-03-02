import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_tracker/app/home/jobs/add_job_page.dart';
import 'package:timer_tracker/app/home/model/Job.dart';
import 'package:timer_tracker/common_widgets/show_alert_dialog.dart';
import 'package:timer_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:timer_tracker/services/auth.dart';
import 'package:timer_tracker/services/database.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await Provider.of<AuthBase>(context, listen: false).signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final showRequestAccept = await showAlertDialog(context,
        title: "Logout",
        content: "Are you sure that you want to logout?",
        defaultActionText: "Yes",
        cancelActionText: "No",
        allowBarrierDismissible: false);
    if (showRequestAccept) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
        actions: <Widget>[
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: const Text(
                "Log out",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddJobPage.show(context),
        child: const Icon(Icons.add),
      ),
      body: _buildContext(context),
    );
  }
  Widget _buildContext(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          if (jobs != null) {
            final children = jobs.map((job) => Text(job.name)).toList();
            return Column(
              children: children,
            );
          }
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Some error"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
