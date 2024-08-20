import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/makhon.png'), width: 150, height: 150,),
            Text('Developed by MAKHON', style: TextStyle(fontFamily: 'AbuSayed', fontSize: 20),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset('assets/codeforces.png', width: 30, height: 30),
                  onPressed: () {
                    _launchCF();
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/fb.png', width: 30, height: 30),
                  onPressed: () {
                    _launchFB();
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/github.png', width: 30, height: 30),
                  onPressed: () {
                    _launchGithub();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchCF() async {
    Uri url = Uri.parse('https://codeforces.com/profile/Makhon58');
    if (!await launchUrl(url)) {
      // throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchFB() async {
    Uri url = Uri.parse('https://www.facebook.com/xoticsajib.xoticsajib');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchGithub() async {
    Uri url = Uri.parse('https://github.com/Maksaline');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

}
