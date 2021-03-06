class Trip {
  String? id;
  final String guideId;
  String? touristId;
  bool? guideAcceptance;
  bool? touristAcceptance;
  final DateTime goalDate;
  final String goalCountry;
  final String goalCity;
  String? lastMessage;
  DateTime? lastMessageTime;
  String? guideName;
  String? touristName;

  Trip({
    this.id,
    required this.guideId,
    this.touristId,
    this.guideAcceptance,
    this.touristAcceptance,
    required this.goalCountry,
    required this.goalCity,
    required this.goalDate,
    this.lastMessage,
    this.lastMessageTime,
    this.guideName,
    this.touristName,
  });

  Trip.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        guideId = json['guideId'],
        touristId = json['touristId'],
        guideAcceptance = json['guideAcceptance'],
        touristAcceptance = json['touristAcceptance'],
        goalCountry = json['goalCountry'],
        goalCity = json['goalCity'],
        goalDate = json['goalDate'],
        lastMessage = json['lastMessage'],
        lastMessageTime = json['lastMessageTime'],
        guideName = json['guideName'],
        touristName = json['touristName'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'guideId': guideId,
        'touristId': touristId,
        'guideAcceptance': guideAcceptance,
        'touristAcceptance': touristAcceptance,
        'goalCountry': goalCountry,
        'goalCity': goalCity,
        'goalDate': goalDate,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime,
        'guideName': guideName,
        'touristName': touristName,
      };
}
