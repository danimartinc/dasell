class UserVo2 {
  String? _uid, _profilePicture, _name, _email, _token, _status;

  UserVo2({
    String? uid,
    String? profilePicture,
    String? name,
    String? email,
    String? token,
    String? status,
  }) {
    this._uid = uid;
    this._profilePicture = profilePicture;
    this._name = name;
    this._email = email;
    this._token = token;
    this._status = status;
  }

  String get uid => _uid!;

  String? get profilePicture => _profilePicture;

  String? get name => _name;

  String? get email => _email;

  String? get token => _token;

  String? get status => _status;

  @override
  String toString() {
    return 'UserVo2{_uid: $_uid, _profilePicture: $_profilePicture, _name: $_name, _email: $_email, _token: $_token, _status: $_status}';
  }

  UserVo2.fromJson(dynamic json) {
    _uid = json['uid'];
    _profilePicture = json['profilePicture'];
    _name = json['name'];
    _email = json['email'];
    _token = json['token'];
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this._uid;
    data['profilePicture'] = this._profilePicture;
    data['name'] = this._name;
    data['email'] = this._email;
    data['token'] = this._token;
    data['status'] = this._status;
    return data;
  }
}
