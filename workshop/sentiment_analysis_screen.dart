import 'package:flutter/material.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

class SentimentAnalysisScreen extends StatefulWidget {
  final List<String> commits;
  final void Function(String vibe) onVibeDetected;
  const SentimentAnalysisScreen({Key? key, required this.commits, required this.onVibeDetected}) : super(key: key);

  @override
  State<SentimentAnalysisScreen> createState() => _SentimentAnalysisScreenState();
}

class _SentimentAnalysisScreenState extends State<SentimentAnalysisScreen> {
  bool _loading = true;
  String? _error;
  String? _vibe;

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final sentiment = Sentiment();
      List<double> scores = widget.commits.map((msg) {
        final result = sentiment.analysis(msg, emoji: true);
        return (result['score'] as num).toDouble();
      }).toList();
      if (scores.isEmpty) {
        setState(() => _error = 'No commit messages to analyze');
        return;
      }
      double avgScore = scores.reduce((a, b) => a + b) / scores.length;
      String vibe = _mapScoreToVibe(avgScore);
      setState(() {
        _vibe = vibe;
        _loading = false;
      });
      widget.onVibeDetected(vibe);
    } catch (e) {
      setState(() => _error = 'Error analyzing sentiment');
    }
  }

  String _mapScoreToVibe(double score) {
    if (score > 2) return 'energetic';
    if (score > 0.5) return 'positive';
    if (score > -0.5) return 'neutral';
    if (score > -2) return 'reflective';
    return 'negative';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analyzing Vibe')),
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
                        onPressed: _analyze,
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_emotions, color: Colors.orange, size: 48),
                      const SizedBox(height: 16),
                      Text('Detected vibe: $_vibe'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => widget.onVibeDetected(_vibe!),
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
