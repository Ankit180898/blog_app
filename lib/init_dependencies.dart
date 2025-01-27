import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_logout.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_user_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/edit_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/filter_blogs_by_category.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/get_user_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/search_blog_post.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Get environment variables
  final supaUri = dotenv.env['SUPABASE_URL'];
  final supaAnon = dotenv.env['SUPABASE_ANONKEY'];

  // Check if environment variables are properly loaded
  if (supaUri == null || supaAnon == null) {
    throw Exception('Missing Supabase credentials in the .env file');
  }

  // Initialize Supabase
  final supabase = await Supabase.initialize(
    url: supaUri,
    anonKey: supaAnon,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // UseCases
    ..registerFactory(
      () => UserSignUp(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogout(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
          userLogout: serviceLocator(),
        ));
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
      ),
    )
    // UseCases
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    // Search blogs use case
    ..registerFactory(
      () => SearchBlogPosts(
        serviceLocator(),
      ),
    )
    // Filter blogs use case
    ..registerFactory(
      () => FilterBlogPostsByCategory(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteUserBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetUserBlogs(
        serviceLocator(),
      ),
    )

    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
        searchBlogPosts: serviceLocator(),
        filterBlogPostsByCategory: serviceLocator(),
        editBlog: serviceLocator(),
        deleteBlog: serviceLocator(),
        getUserBlogs: serviceLocator(),
      ),
    );
}
