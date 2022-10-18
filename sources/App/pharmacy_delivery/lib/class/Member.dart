class Member {
  String? MemberUsername;
  String? MemberPassword;
  String? MemberName;
  String? MemberGender;
  String? MemberTel;
  String? MemberEmail;
  String? MemberImg;

  Member.login(this.MemberUsername, this.MemberPassword);

  Member({
    this.MemberUsername,
    this.MemberPassword,
    this.MemberName,
    this.MemberGender,
    this.MemberTel,
    this.MemberEmail,
    this.MemberImg,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      MemberUsername: json["MemberUsername"] == null ? null : json["MemberUsername"] ,
      MemberPassword: json["MemberPassword"] == null ? null : json["MemberPassword"] ,
      MemberName: json["MemberName"] == null ? null : json["MemberName"],
      MemberGender: json["MemberGender"] == null ? null : json["MemberGender"],
      MemberTel: json["MemberTel"] == null ? null : json["MemberTel"],
      MemberEmail: json["MemberEmail"] == null ? null : json["MemberEmail"],
      MemberImg: json["MemberImg"] == null ? null : json["MemberImg"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "MemberUsername": this.MemberUsername == null ? null : this.MemberUsername,
      "MemberPassword": this.MemberPassword == null ? null :this.MemberPassword,
      "MemberName": this.MemberName == null ? null : this.MemberName,
      "MemberGender": this.MemberGender == null ? null : this.MemberGender,
      "MemberTel": this.MemberTel == null ? null : this.MemberTel,
      "MemberEmail": this.MemberEmail == null ? null : this.MemberEmail,
      "MemberImg": this.MemberImg == null ? null : this.MemberImg,
    };
  }

  Map<String, dynamic> toJsonLogin() {
    return {
      "MemberUsername": this.MemberUsername == null ? null : this.MemberUsername,
      "MemberPassword": this.MemberPassword == null ? null :this.MemberPassword,
    };
  }
}
