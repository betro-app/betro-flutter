import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileProvider = StateNotifierProvider<Profile, ProfileState>((ref) {
  return Profile();
});

class Profile extends StateNotifier<ProfileState> {
  Profile() : super(ProfileState());

  void profileLoaded({
    String? user_id,
    String? username,
    String? email,
    String? first_name,
    String? last_name,
  }) {
    state = state.copyWith(
      isLoaded: true,
      user_id: user_id,
      username: username,
      email: email,
      first_name: first_name,
      last_name: last_name,
    );
  }

  void profilePictureLoaded(List<int>? profile_picture) {
    state = state.copyWith(
      isProfilePictureLoaded: true,
      profile_picture: profile_picture,
    );
  }
}

class ProfileState {
  final bool isLoaded;
  final bool isProfilePictureLoaded;
  final String? user_id;
  final String? username;
  final String? email;
  final String? first_name;
  final String? last_name;
  final List<int>? profile_picture;

  ProfileState({
    this.isLoaded = false,
    this.isProfilePictureLoaded = false,
    this.user_id,
    this.username,
    this.email,
    this.first_name,
    this.last_name,
    this.profile_picture,
  });

  ProfileState copyWith({
    bool? isLoaded,
    bool? isProfilePictureLoaded,
    String? user_id,
    String? username,
    String? email,
    String? first_name,
    String? last_name,
    List<int>? profile_picture,
  }) =>
      ProfileState(
        isLoaded: isLoaded ?? this.isLoaded,
        isProfilePictureLoaded:
            isProfilePictureLoaded ?? this.isProfilePictureLoaded,
        user_id: user_id ?? this.user_id,
        username: username ?? this.username,
        email: email ?? this.email,
        first_name: first_name ?? this.first_name,
        last_name: last_name ?? this.last_name,
        profile_picture: profile_picture ?? this.profile_picture,
      );
}
