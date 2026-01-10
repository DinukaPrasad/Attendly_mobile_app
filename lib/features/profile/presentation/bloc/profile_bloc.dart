import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_students.dart';
import '../../domain/usecases/get_users.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC for handling profile and student data
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetAllStudents getAllStudents;
  final GetUsers getUsers;

  ProfileBloc({required this.getAllStudents, required this.getUsers})
    : super(const ProfileState.initial()) {
    on<LoadStudents>(_onLoadStudents);
    on<LoadUsers>(_onLoadUsers);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadStudents(
    LoadStudents event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await getAllStudents();

    result.fold(
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      onSuccess: (students) {
        emit(state.copyWith(status: ProfileStatus.loaded, students: students));
      },
    );
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await getUsers(GetUsersParams(count: event.count));

    result.fold(
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      onSuccess: (users) {
        emit(state.copyWith(status: ProfileStatus.loaded, users: users));
      },
    );
  }

  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // Re-load whatever data we currently have
    if (state.students.isNotEmpty) {
      add(const LoadStudents());
    }
    if (state.users.isNotEmpty) {
      add(const LoadUsers());
    }
  }
}
