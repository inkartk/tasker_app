import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_the_best_project/features/profile/data/model.dart';
import 'package:my_the_best_project/features/profile/data/profile_repository.dart';

class ProfileState {
  final bool loading;
  final UserProfile? profile;
  final String? error;
  ProfileState({this.loading = false, this.profile, this.error});
}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repo;
  ProfileCubit(this.repo) : super(ProfileState(loading: true)) {
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await repo.fetchProfile();
      emit(ProfileState(profile: p));
    } catch (e) {
      emit(ProfileState(error: e.toString()));
    }
  }

  Future<void> saveChanges({
    required String name,
    required String profession,
    required DateTime birthDate,
  }) async {
    final p = state.profile!;
    p.name = name;
    p.profession = profession;
    p.birthDate = birthDate;
    emit(ProfileState(loading: true, profile: p));
    try {
      await repo.updateProfile(p);
      final user = FirebaseAuth.instance.currentUser!;
      await user.updateDisplayName(p.name);
      await user.reload();
      emit(ProfileState(profile: p));
    } catch (e) {
      emit(ProfileState(error: e.toString(), profile: p));
    }
  }
}
