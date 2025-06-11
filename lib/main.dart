import 'package:flutter/material.dart';
import 'workshop/github_handle_screen.dart';
import 'workshop/commit_fetch_screen.dart';
import 'workshop/sentiment_analysis_screen.dart';
import 'workshop/song_recommendation_screen.dart';

void main() {
  runApp(const GitDrakeApp());
}

class GitDrakeApp extends StatelessWidget {
  const GitDrakeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitDrake',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: _GitDrakeFlow(),
    );
  }
}

class _GitDrakeFlow extends StatefulWidget {
  @override
  State<_GitDrakeFlow> createState() => _GitDrakeFlowState();
}

class _GitDrakeFlowState extends State<_GitDrakeFlow> {
  String? _handle;
  List<String>? _commits;
  String? _vibe;

  @override
  Widget build(BuildContext context) {
    if (_handle == null) {
      return GitHubHandleScreen(
        onValidHandle: (handle) => setState(() => _handle = handle),
      );
    } else if (_commits == null) {
      return CommitFetchScreen(
        handle: _handle!,
        onCommitsFetched: (commits) => setState(() => _commits = commits),
      );
    } else if (_vibe == null) {
      return SentimentAnalysisScreen(
        commits: _commits!,
        onVibeDetected: (vibe) => setState(() => _vibe = vibe),
      );
    } else {
      return SongRecommendationScreen(vibe: _vibe!);
    }
  }
}
