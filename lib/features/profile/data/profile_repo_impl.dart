import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_the_best_project/features/profile/data/model.dart';

import 'profile_repository.dart';

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseProfileRepository({
    required this.auth,
    required this.firestore,
    required this.storage,
  });

  @override
  Future<UserProfile> fetchProfile() async {
    final user = auth.currentUser!;
    final doc = await firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      final defaultProfile = UserProfile(
        id: user.uid,
        email: user.email!,
        name: '',
        profession: '',
        birthDate: DateTime(2000, 1, 1),
        avatarUrl: null,
      );
      await firestore.collection('users').doc(user.uid).set({
        'name': defaultProfile.name,
        'profession': defaultProfile.profession,
        'birthDate': Timestamp.fromDate(defaultProfile.birthDate),
        'avatarUrl': null,
      });
      return defaultProfile;
    }

    final data = doc.data()!;
    return UserProfile(
      id: user.uid,
      email: user.email!,
      name: data['name'] as String,
      profession: data['profession'] as String,
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      avatarUrl: data['avatarUrl'] as String?,
    );
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    await firestore.collection('users').doc(profile.id).update({
      'name': profile.name,
      'profession': profile.profession,
      'birthDate': Timestamp.fromDate(profile.birthDate),
      if (profile.avatarUrl != null) 'avatarUrl': profile.avatarUrl,
    });
  }
}
