import 'package:social/features/messenger/data/models/user_info_model.dart';
import 'package:taakitecture/taakitecture.dart';
import 'message_model.dart';

class MessagerModel extends BaseModel with ModelMixin {
  late List<MessagesModel> messages;
  late String name;
  late UserInfoModel userInfo;
  late List<String> rejectList;

  @override
  BaseModel getInstance() => MessagerModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'items':
        messages = [for (var mapJson in value) MessagesModel().fromJson(mapJson)];
        break;
      case 'name':
        name = value;
        break;
      case 'userInfo':
        userInfo = UserInfoModel().fromJson(value);
        break;
      case 'rejectList':
        rejectList = [for (var text in value) text.toString()];
        break;
    }
  }
}
