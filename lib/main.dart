import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/providers/fetch_characters_provider.dart';

// Theme mode provider to toggle light and dark mode
Type ThemeModeProvider = StateProvider<ThemeMode>;
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

void main() {
  runApp(const ProviderScope(child: RickAndMorty()));
}

class RickAndMorty extends ConsumerWidget {
  const RickAndMorty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode, // Adapts to system settings
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Characters"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
            onPressed: () {
              // Toggle between light and dark mode
              ref.read(themeModeProvider.notifier).state =
                  themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: ref.watch(fetchCharactersProvider).maybeWhen(
            fetching: () => const Center(child: CircularProgressIndicator()),
            fetched: (characters) => ListView(
              children: characters
                  .map(
                    (e) => ListTile(
                      title: Text(e.name!),
                      leading: Image.network(e.image!,
                          height: 100, fit: BoxFit.cover),
                      subtitle: Text(e.status!),
                    ),
                  )
                  .toList(),
            ),
            orElse: () => Container(),
          ),
    );
  }
}
