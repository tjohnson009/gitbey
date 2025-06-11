import 'package:flutter/material.dart';

class GitHubHandleScreen extends StatefulWidget {
  final void Function(String handle) onValidHandle;
  const GitHubHandleScreen({Key? key, required this.onValidHandle}) : super(key: key);

  @override
  State<GitHubHandleScreen> createState() => _GitHubHandleScreenState();
}

class _GitHubHandleScreenState extends State<GitHubHandleScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  bool _isValidHandle(String input) {
    final regex = RegExp(r'^(?!-)[a-zA-Z0-9-]{1,39}(?<!-)[0m');
    return regex.hasMatch(input);
  }

  void _onSubmit() {
    final handle = _controller.text.trim();
    if (handle.isEmpty || !_isValidHandle(handle)) {
      setState(() {
        _error = 'Invalid GitHub handle';
      });
    } else {
      setState(() {
        _error = null;
      });
      widget.onValidHandle(handle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitDrake')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your GitHub handle',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'GitHub handle',
                errorText: _error,
              ),
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onSubmit(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
