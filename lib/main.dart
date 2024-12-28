import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard functionality
import 'package:url_launcher/url_launcher.dart'; // URL launching

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // Flag for Dark Mode

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M3U Link Parser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
        title: 'M3U Link Parser',
        onToggleDarkMode: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onToggleDarkMode,
  });
  final String title;
  final VoidCallback onToggleDarkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _linkController = TextEditingController();
  String _output = '';

  // Function to parse the M3U link
  void _parseLink() {
    String inputLink = _linkController.text.trim();

    if (inputLink.isEmpty) {
      _showSnackbar('Please enter a valid M3U link!');
      return;
    }

    try {
      final uri = Uri.parse(inputLink);
      final username = uri.queryParameters['username'] ?? '';
      final password = uri.queryParameters['password'] ?? '';
      final baseUrl = uri.origin;

      setState(() {
        _output = '''
M3U-Link:
$inputLink

Xtream Code:
Name : VIP
Username : $username
Password : $password
URL : $baseUrl
        ''';
      });
    } catch (e) {
      _showSnackbar('Invalid M3U link!');
    }
  }

  // Function to copy output to clipboard
  void _copyToClipboard() {
    if (_output.isEmpty) {
      _showSnackbar('No output to copy!');
      return;
    }
    Clipboard.setData(ClipboardData(text: _output));
    _showSnackbar('Output copied to clipboard!');
  }

  // Function to launch a URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnackbar('Could not launch $url');
    }
  }

  // Function to show a snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: widget.onToggleDarkMode,
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Field
              TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  labelText: 'Enter M3U Link',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link, color: Theme.of(context).colorScheme.primary),
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Generate Output Button
              ElevatedButton.icon(
                onPressed: _parseLink,
                icon: const Icon(Icons.settings),
                label: const Text('Generate Output'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Display Output
              if (_output.isNotEmpty) ...[
                const Text(
                  'Parsed Output:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _output,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],

              // Copy Output Button
              ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy),
                label: const Text('Copy Output'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 16),

              // Navigation Buttons
              ElevatedButton.icon(
                onPressed: () =>
                    _launchUrl('https://iboplayer.pro/manage-playlists/login/'),
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Go to IBO Player Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _launchUrl('https://iboplayer.com/'),
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Go to IBO Player Website'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _launchUrl('https://vuplayer.pro/login'),
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Go to VU Player Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
