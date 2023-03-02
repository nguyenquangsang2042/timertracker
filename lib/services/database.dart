import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timer_tracker/app/home/model/Job.dart';
import 'package:timer_tracker/services/api_path.dart';
import 'package:timer_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);

  Stream<List<Job>> jobsStream();
}
String documentIDFromCurrentDate()=>DateTime.now().toIso8601String();
class FireStoreDatabase implements Database {
  FireStoreDatabase({required this.uid});

  final String uid;
  final _service=FireStoreService.instance;
  @override
  Future<void> createJob(Job job) async =>
      _service.setData(path: APIPath.job(uid, documentIDFromCurrentDate()), data: job.toMap());

  @override
  Stream<List<Job>> jobsStream() =>_service.collectionStream(path: APIPath.jobs(uid), builder: (data)=>Job.fromMap(data));
}
