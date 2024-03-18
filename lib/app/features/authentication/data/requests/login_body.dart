class LoginBody {
  final String login;
  final String password;

  LoginBody({
    required this.login,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'grant_type': 'password',
        'UserName': login,
        'Password': password,
      };
}
