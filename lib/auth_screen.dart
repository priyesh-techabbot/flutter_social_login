import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_login/loader.dart';
import 'package:github_oauth/github_oauth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Social Auth"),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: signInWithTwitter,
                  child: Container(
                    width: width / 2,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 10),
                        Image.asset(
                          'assets/X_logo.jpg',
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Signin With X",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: signinWithGoogle,
                  child: Container(
                    width: width / 2,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/google_icon.png',
                          height: 25,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Signin With Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: signInWithGitHub,
                  child: Container(
                    width: width / 2,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/github.png',
                          height: 25,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Signin With Github",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) const LoadingPage(),
        ],
      ),
    );
  }

  Future<void> signinWithFacebook() async {}

  Future<void> signInWithTwitter() async {
    try {
      isLoading = true;
      setState(() {});
      // Create a TwitterLogin instance
      final twitterLogin = TwitterLogin(
          apiKey: 'EP4JF7B7y8q4JFBCONrLAM8XN',
          apiSecretKey: 'sdRKurpBeAUCdBV7F4IznqlJcKnN33hvvnPOP29gr4qbiIzjil',
          redirectURI: 'socialflutterdemo://');

      // Trigger the sign-in flow
      final authResult = await twitterLogin.login();

      if (authResult.authToken != null) {
        // Create a credential from the access token
        final twitterAuthCredential = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!,
        );

        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
      } else {
        isLoading = false;
        setState(() {});
      }
    } catch (e, s) {
      isLoading = false;
      setState(() {});

      print(e);
      print(s);
    }
  }

  Future<void> signinWithGoogle() async {
    try {
      isLoading = true;
      setState(() {});

      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        isLoading = false;
        setState(() {});
      }
    } catch (e, s) {
      isLoading = false;
      setState(() {});

      print(e);
      print(s);
    }
  }

  Future<void> signInWithGitHub() async {
    try {
      isLoading = true;
      setState(() {});
      // Create a GitHubSignIn instance
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
          clientId: 'Ov23liWt0SNuzdFsVRSG',
          clientSecret: 'c9030b01cf56e0bf2ed10145dabb90a96ed101f5',
          redirectUrl:
              'https://flutter-social-login-1f174.firebaseapp.com/__/auth/handler');

      // Trigger the sign-in flow
      final result = await gitHubSignIn.signIn(context);

      if (result.token != null) {
        // Create a credential from the access token
        final githubAuthCredential =
            GithubAuthProvider.credential(result.token!);

        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);

        if (result.userProfile!['name'] == null) {
          await FirebaseAuth.instance.currentUser
              ?.updateDisplayName(result.userProfile!['login']);
        }
      } else {
        isLoading = false;
        setState(() {});
      }
    } catch (e, s) {
      isLoading = false;
      setState(() {});

      print(e);
      print(s);
    }
  }
}
