import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final databaseProvider =
    Provider<FirebaseFirestore?>((ref) => FirebaseFirestore.instance);

final realtimeDatabaseProvider =
    Provider<FirebaseDatabase>((ref) => FirebaseDatabase.instance);

final fireStoreProvider =
    Provider<FirebaseStorage?>((ref) => FirebaseStorage.instance);

final firebaseFunctionProvider = Provider<FirebaseFunctions?>(
    (ref) => FirebaseFunctions.instanceFor(region: 'europe-west1'));
