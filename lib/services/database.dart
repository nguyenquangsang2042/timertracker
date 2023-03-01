import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timer_tracker/app/home/model/Job.dart';
import 'package:timer_tracker/services/api_path.dart';

abstract class Database
{
  void createJob(Job job);
  void readJobs();
}
class FireStoreDatabase implements Database{
  FireStoreDatabase({required this.uid});
  final String uid;
  @override
  void createJob(Job job) async => _setData(path: APIPath.job(uid, "JobBCD11111"), data: job.toMap());
  Future<void> _setData({required String path,required Map<String,dynamic> data}) async
  {
    final reference=FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }
  @override
  void readJobs() {
    final path= APIPath.jobs(uid);
    final reference=FirebaseFirestore.instance.collection(path);
    final snapshots=reference.snapshots();
    snapshots.listen((snapshot) {
      snapshot.docs.forEach((snapshot) {print(snapshot.data()); });
    });
  }
}