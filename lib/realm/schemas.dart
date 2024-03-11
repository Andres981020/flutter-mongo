import 'package:realm/realm.dart';

part 'schemas.g.dart';

@RealmModel()
class _Item {
  @MapTo('_id')
  @PrimaryKey()
  late ObjectId id;
  bool isComplete = false;
  late String summary;
  @MapTo('owner_id')
  late String ownerId;
}

@RealmModel()
class _Producto {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  @MapTo('owner_id')
  late String ownerId;
  @MapTo('product_name') 
  late String productName;
  late double stock;
}
