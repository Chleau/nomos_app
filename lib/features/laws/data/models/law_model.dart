import 'package:nomos_app/features/laws/domain/entities/law.dart';

class LawModel extends Law {
  LawModel({
    required super.id,
    required super.titre,
    required super.contenu,
    required super.thematique,
    super.dateMiseAJour,
  });

  factory LawModel.fromJson(Map<String, dynamic> json) {
    return LawModel(
      id: json['id'] as int,
      titre: json['titre'] as String,
      contenu: json['contenu'] as String,
      thematique: json['thematique'] as String,
      dateMiseAJour: json['date_mise_a_jour'] != null
          ? DateTime.parse(json['date_mise_a_jour'] as String)
          : null,
    );
  }

  Law toEntity() {
    return Law(
      id: id,
      titre: titre,
      contenu: contenu,
      thematique: thematique,
      dateMiseAJour: dateMiseAJour,
    );
  }
}
