import 'package:social/core/app/utils/classes/app_datetime.dart';
import 'package:taakitecture/taakitecture.dart';

enum MessageSide { doctor, user }

enum MediaType { invalid, file, image, audio, video }

class MessagesModel extends BaseModel with ModelMixin {
  String? id;
  String? clientId;
  String? media;
  late String text;
  late String displayMediaName;
  late AppDateTime time;
  late MessageSide side;
  late MediaType mediaType;

  @override
  BaseModel getInstance() => MessagesModel();

  @override
  Map<String, dynamic> get properties => {
        'clientId': clientId,
        'text': text,
        'mediaName': media,
      };

  bool get isOwner => side == MessageSide.doctor;

  @override
  List<Object?> get props => [id];

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'id':
        id = value;
        break;
      case 'clientId':
        clientId = value;
        break;
      case 'createTime':
        time = AppDateTime.parse(value);
        break;
      case 'text': // TODO: Nullable
        text = value;
        break;
      case 'side':
        side = MessageSide.values[value];
        break;
      case 'mediaType':
        mediaType = MediaType.values[value];
        break;
      case 'mediaName':
        media = value ?? "";
        break;
      case 'displayMediaName':
        displayMediaName = value ?? "";
        break;
    }
  }
}
