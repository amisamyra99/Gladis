import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';

class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarScope],
  );

  Future<GoogleSignInAccount?> signIn() async {
    return await _googleSignIn.signIn();
  }

  Future<calendar.CalendarApi> getCalendarApi(GoogleSignInAccount account) async {
    final authHeaders = await account.authHeaders;
    final authenticateClient = AuthenticatedClient(http.Client(), authHeaders);
    return calendar.CalendarApi(authenticateClient);
  }
}

class AuthenticatedClient extends http.BaseClient {
  final http.Client _inner;
  final Map<String, String> _headers;

  AuthenticatedClient(this._inner, this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request..headers.addAll(_headers));
  }
}
