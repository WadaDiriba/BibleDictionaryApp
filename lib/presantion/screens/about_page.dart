import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About EL-ROI LEXICON"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // App description
            const Text(
              "EL-ROI LEXICON",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "EL-ROI LEXICON is a dictionary and learning platform  which Contain five languages: Afaan Oromo, Amharic, Hebrew, English, and Greek. It is"
              "designed to support language study and spiritual growth.",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Contributors title
            const Text(
              "Contributors",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Contributors list
            buildContributor("Wada Diriba", "Software Developer and Translation Consultant"),
            buildContributor("Gedefa Mengash (PhD)", "Translation Consultant"),
            buildContributor("Kisi Abdata (PhD)", "Translation Consultant"),
            buildContributor("Dereje Aberra", "Translation Consultant"),

          ],
        ),
      ),
    );
  }

  // Reusable widget
  Widget buildContributor(String name, String role) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(name),
        subtitle: Text(role),
      ),
    );
  }
}
