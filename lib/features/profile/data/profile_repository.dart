import 'package:my_the_best_project/features/profile/data/model.dart';

abstract class ProfileRepository {
  Future<UserProfile> fetchProfile();
  Future<void> updateProfile(UserProfile profile);
}
