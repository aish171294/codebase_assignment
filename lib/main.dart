import 'package:code_base_assignment/core/connectivity/connectivity_bloc.dart';
import 'package:code_base_assignment/core/connectivity/network_info.dart';
import 'package:code_base_assignment/core/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/di/di_injection.dart';
import 'core/routes/route_names.dart';
import 'features/auth/data/model/user_model.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/todo/data/model/todo_model.dart';

import 'features/todo/presentation/bloc/todo/todo_bloc.dart';
import 'features/todo/presentation/screens/todo_screen.dart';
import 'features/todo/presentation/widget/no_internet_widget.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todoBox');
  await init();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: BlocProvider(
        create: (context) => ConnectivityBloc(sl<ConnectivityService>()),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
            BlocProvider<TodoBloc>(create: (_) => sl<TodoBloc>()),
          ],
          child: MaterialApp(
            builder: (context, child) {
              return Stack(
                children: [
                  child ?? const SizedBox(),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: NoInternetWidget(),
                  ),
                ],
              );
            },
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(primarySwatch: Colors.blue),
            initialRoute: RouteNames.login,
            onGenerateRoute: AppRoutes.generateRoute,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is Authenticated) {
                  return const TodoScreen();
                } else if (state is Unauthenticated) {
                  return LoginScreen();
                }
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  }
}



