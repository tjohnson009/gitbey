import 'package:flutter/material.dart';

final Map<String, List<Map<String, String>>> drakeSongsByVibe = {
  'energetic': [
    {'title': 'Nonstop', 'album': 'Scorpion'},
    {'title': 'Started From the Bottom', 'album': 'Nothing Was the Same'},
    {'title': 'Jumpman', 'album': 'What a Time to Be Alive'},
    {'title': 'Energy', 'album': 'If You’re Reading This It’s Too Late'},
    {'title': 'Headlines', 'album': 'Take Care'},
  ],
  'positive': [
    {'title': 'One Dance', 'album': 'Views'},
    {'title': 'Find Your Love', 'album': 'Thank Me Later'},
    {'title': 'Hold On, We’re Going Home', 'album': 'Nothing Was the Same'},
    {'title': 'Passionfruit', 'album': 'More Life'},
    {'title': 'Toosie Slide', 'album': 'Dark Lane Demo Tapes'},
  ],
  'neutral': [
    {'title': 'God’s Plan', 'album': 'Scorpion'},
    {'title': 'Controlla', 'album': 'Views'},
    {'title': 'Nice for What', 'album': 'Scorpion'},
    {'title': 'Fake Love', 'album': 'More Life'},
    {'title': 'The Motto', 'album': 'Take Care'},
  ],
  'reflective': [
    {'title': 'Marvins Room', 'album': 'Take Care'},
    {'title': 'Jungle', 'album': 'If You’re Reading This It’s Too Late'},
    {'title': 'From Time', 'album': 'Nothing Was the Same'},
    {'title': 'Fire & Desire', 'album': 'Views'},
    {'title': 'Redemption', 'album': 'Views'},
  ],
  'negative': [
    {'title': 'Emotionless', 'album': 'Scorpion'},
    {'title': 'Do Not Disturb', 'album': 'More Life'},
    {'title': 'The Ride', 'album': 'Take Care'},
    {'title': 'Lose You', 'album': 'More Life'},
    {'title': 'Look What You’ve Done', 'album': 'Take Care'},
  ],
};

class SongRecommendationScreen extends StatelessWidget {
  final String vibe;
  const SongRecommendationScreen({Key? key, required this.vibe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songs = drakeSongsByVibe[vibe] ?? drakeSongsByVibe['neutral']!;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Drake Playlist')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vibe: $vibe', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...songs.map((song) => ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(song['title']!),
                  subtitle: Text(song['album']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      // TODO: Integrate playback (Spotify/YouTube)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Playback not implemented.')),
                      );
                    },
                  ),
                )),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Share Playlist'),
                onPressed: () {
                  // TODO: Integrate sharing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing not implemented.')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
