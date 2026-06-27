import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';
import 'app/shared/theme/theme.dart';
import 'app/shared/theme/colors.dart';
import 'app/shared/theme/app_theme_provider.dart';
import 'app/shared/utils/utils.dart';
import 'app/ui/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ToastificationWrapper(
      config: ToastificationConfig(
        alignment: Alignment.center,
        animationDuration: const Duration(milliseconds: 200),
        animationBuilder: (context, animation, alignment, child) {
          return ScaleTransition(
            scale: Tween(begin: 0.5, end: 1.0).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
      child: GlobalLoaderOverlay(
        overlayColor: Colors.black54,
        overlayWidgetBuilder: (_) {
          return const Center(
            child: Card(
              color: Colors.white,
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  backgroundColor: Colors.black12,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  strokeCap: StrokeCap.round,
                  color: AppColors.cyanAccent,
                ),
              ),
            ),
          );
        },
        child: MaterialApp(
          title: AppUtils.appLabel,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const MainShell(),
        ),
      ),
    );
  }
}