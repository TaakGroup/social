import 'package:taakitecture/taakitecture.dart';

class ProfileModel extends BaseModel with ModelMixin {
  late String id;
  String? medicalNumber;
  late String username;
  late String expertise;
  late String biography;
  String? avatarImage;

  @override
  BaseModel getInstance() => ProfileModel();

  @override
  Map<String, dynamic> get properties => {
        "id": id,
        "medicalNumber": medicalNumber,
        "username": username,
        "expertise": expertise,
        "biography": biography,
        "avatarImage": avatarImage,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "id":
      case "userId":
        id = value;
        break;
      case "medicalNumber":
        medicalNumber = value;
        break;
      case "username":
        username = value;
        break;
      case "expertise":
        expertise = value;
        break;
      case "biography":
        biography = value;
        break;
      case "avatarImage":
        avatarImage = value;
        break;
    }
  }
}
