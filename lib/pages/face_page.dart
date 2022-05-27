import 'package:NotesLock/api/local_auth_api.dart';
import "package:NotesLock/main.dart";
import 'package:NotesLock/pages/notes_page.dart';
import 'package:flutter/material.dart';

//This the page which appears after the splashscreen.
//This is the page where authentication is performed.

class FacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(),
                SizedBox(height: 24),
                buildAuthenticate(context),
              ],
            ),
          ),
        ),
      );

  Widget buildText(String text, bool checked) => Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            checked
                ? Icon(Icons.check, color: Colors.green, size: 24)
                : Icon(Icons.close, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 24)),
          ],
        ),
      );

//This the button clicked for authenticating.

  bool _isAuthenticated = false;
  Widget buildAuthenticate(BuildContext context) => buildButton(
        text: "Click to Authenticate",
        icon: Icons.lock_open,
        onClicked: () async {
          final String res = await LocalAuthApi.authenticate(
            messageReason: 'Authenticate to access app',
          );
          if (res == "authenticated") {
            _isAuthenticated = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      NotesPage()), // If user is authenticated then this commands sends her/him to the next notes page.
            );
          }
        },
      );

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
        ),
        icon: Icon(icon, size: 26),
        label: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
      );

  Widget buildHeader() => Column(
        children: [
          SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (bounds) {
              final colors = [Colors.blueAccent, Colors.pink];
              return RadialGradient(colors: colors).createShader(bounds);
            },
          ),
        ],
      );
}
