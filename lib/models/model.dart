class QuranResponse {
  QuranResponse({
    required this.code,
    required this.status,
    required this.data,
  });
  late final int code;
  late final String status;
  late final Data data;

  QuranResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['status'] = status;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.surahs,
    required this.edition,
  });
  late final List<Surahs> surahs;
  late final Edition edition;

  Data.fromJson(Map<String, dynamic> json) {
    surahs = List.from(json['surahs']).map((e) => Surahs.fromJson(e)).toList();
    edition = Edition.fromJson(json['edition']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['surahs'] = surahs.map((e) => e.toJson()).toList();
    _data['edition'] = edition.toJson();
    return _data;
  }
}

class Surahs {
  Surahs({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });
  late final int number;
  late final String name;
  late final String englishName;
  late final String englishNameTranslation;
  late final String revelationType;
  late final List<Ayahs> ayahs;

  Surahs.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    englishName = json['englishName'];
    englishNameTranslation = json['englishNameTranslation'];
    revelationType = json['revelationType'];
    ayahs = List.from(json['ayahs']).map((e) => Ayahs.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['number'] = number;
    _data['name'] = name;
    _data['englishName'] = englishName;
    _data['englishNameTranslation'] = englishNameTranslation;
    _data['revelationType'] = revelationType;
    _data['ayahs'] = ayahs.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Ayahs {
  Ayahs({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });
  late final int number;
  late final String text;
  late final int numberInSurah;
  late final int juz;
  late final int manzil;
  late final int page;
  late final int ruku;
  late final int hizbQuarter;
  late final bool? sajda;

  Ayahs.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    text = json['text'];
    numberInSurah = json['numberInSurah'];
    juz = json['juz'];
    manzil = json['manzil'];
    page = json['page'];
    ruku = json['ruku'];
    hizbQuarter = json['hizbQuarter'];
    sajda = json['sajda'].toString().toLowerCase() == 'true' ? true : false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['number'] = number;
    _data['text'] = text;
    _data['numberInSurah'] = numberInSurah;
    _data['juz'] = juz;
    _data['manzil'] = manzil;
    _data['page'] = page;
    _data['ruku'] = ruku;
    _data['hizbQuarter'] = hizbQuarter;
    _data['sajda'] = sajda;
    return _data;
  }
}

class Sajda {
  Sajda({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });
  late final int id;
  late final bool recommended;
  late final bool obligatory;

  Sajda.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recommended = json['recommended'];
    obligatory = json['obligatory'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['recommended'] = recommended;
    _data['obligatory'] = obligatory;
    return _data;
  }
}

class Edition {
  Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
  });
  late final String identifier;
  late final String language;
  late final String name;
  late final String englishName;
  late final String format;
  late final String type;

  Edition.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    language = json['language'];
    name = json['name'];
    englishName = json['englishName'];
    format = json['format'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['identifier'] = identifier;
    _data['language'] = language;
    _data['name'] = name;
    _data['englishName'] = englishName;
    _data['format'] = format;
    _data['type'] = type;
    return _data;
  }
}
