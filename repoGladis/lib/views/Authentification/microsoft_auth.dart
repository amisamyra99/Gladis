import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'dart:convert';

class MicrosoftAuth {
  final String clientId;
  final String clientSecret;
  final String redirectUrl;
  final List<String> scopes;

  MicrosoftAuth({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    this.scopes = const ['https://graph.microsoft.com/Calendars.Read'],
  });

  Future<oauth2.Client> signIn() async {
    final authorizationEndpoint = Uri.parse('https://login.microsoftonline.com/common/oauth2/v2.0/authorize');
    final tokenEndpoint = Uri.parse('https://login.microsoftonline.com/common/oauth2/v2.0/token');

    final grant = oauth2.AuthorizationCodeGrant(
      clientId,
      authorizationEndpoint,
      tokenEndpoint,
      secret: clientSecret,
    );

    final authorizationUrl = grant.getAuthorizationUrl(Uri.parse(redirectUrl), scopes: scopes);

    final result = await FlutterWebAuth.authenticate(
      url: authorizationUrl.toString(),
      callbackUrlScheme: Uri.parse(redirectUrl).scheme,
    );
    final code = Uri.parse(result).queryParameters['code'];

    return await grant.handleAuthorizationResponse({'code': code!});
  }

  Future<List<Map<String, dynamic>>> getCalendarEvents(oauth2.Client oauthClient) async {
    final response = await oauthClient.get(Uri.parse('https://graph.microsoft.com/v1.0/me/events'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['value']);
    } else {
      throw Exception('Failed to load events');
    }
  }
}
