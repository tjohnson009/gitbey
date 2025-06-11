import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommitFetchScreen extends StatefulWidget {
  final String handle;
  final void Function(List<String> commits) onCommitsFetched;
  const CommitFetchScreen({Key? key, required this.handle, required this.onCommitsFetched}) : super(key: key);

  @override
  State<CommitFetchScreen> createState() => _CommitFetchScreenState();
}

class _CommitFetchScreenState extends State<CommitFetchScreen> {
  bool _loading = true;
  String? _error;
  List<String> _commits = [];

  @override
  void initState() {
    super.initState();
    _fetchCommits();
  }

  Future<void> _fetchCommits() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final url = 'https://api.github.com/users/${widget.handle}/events/public';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 404) {
        setState(() => _error = 'GitHub user not found');
        return;
      }
      if (response.statusCode != 200) {
        setState(() => _error = 'Could not fetch commits');
        return;
      }
      final data = json.decode(response.body);
      final List<String> commits = [];
      for (var event in data) {
        if (event['type'] == 'PushEvent' && event['payload'] != null) {
          final payload = event['payload'];
          if (payload['commits'] != null) {
            for (var commit in payload['commits']) {
              if (commit['message'] != null) {
                commits.add(commit['message']);
                if (commits.length >= 50) break;
              }
            }
          }
        }
        if (commits.length >= 50) break;
      }
      if (commits.isEmpty) {
        setState(() => _error = 'No commits found for this user');
        return;
      }
      setState(() {
        _commits = commits;
        _loading = false;
      });
      widget.onCommitsFetched(commits);
    } catch (e) {
      setState(() => _error = 'Error fetching commits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fetching Commits')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchCommits,
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 16),
                      Text('Fetched ${_commits.length} commits!'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => widget.onCommitsFetched(_commits),
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
