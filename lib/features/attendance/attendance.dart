/// Barrel export for the attendance feature
library;

// Domain
export 'domain/entities/entities.dart';
export 'domain/repositories/attendance_repository.dart';
export 'domain/usecases/usecases.dart';

// Data
export 'data/datasources/datasources.dart';
export 'data/models/models.dart';
export 'data/repositories/attendance_repository_impl.dart';

// Presentation
export 'presentation/bloc/bloc.dart';
export 'presentation/pages/pages.dart';

// Injection
export 'injection.dart';
