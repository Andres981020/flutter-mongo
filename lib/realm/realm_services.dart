import 'package:flutter_todo/realm/schemas.dart';
import 'package:realm/realm.dart';
import 'package:flutter/material.dart';

class RealmServices with ChangeNotifier {
  static const String queryAllName = "getAllItemsSubscription";
  static const String queryMyItemsName = "getMyItemsSubscription";

  bool showAll = false;
  bool offlineModeOn = false;
  bool isWaiting = false;
  late Realm realm;
  User? currentUser;
  App app;

 
  RealmServices(this.app) {
    if (app.currentUser != null || currentUser != app.currentUser) {
      currentUser ??= app.currentUser;
      realm = Realm(Configuration.flexibleSync(currentUser!, [Item.schema]));
      showAll = (realm.subscriptions.findByName(queryAllName) != null);
      if (realm.subscriptions.isEmpty) {
        updateSubscriptions();
      }
    }
  }

  Future<void> updateSubscriptions() async {
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.clear();
      if (showAll) {
        mutableSubscriptions.add(realm.all<Item>(), name: queryAllName);
      } else {
        mutableSubscriptions.add(
            realm.query<Item>(r'owner_id == $0', [currentUser?.id]),
            name: queryMyItemsName);
      }
    });
    await realm.subscriptions.waitForSynchronization();
  }

  Future<void> sessionSwitch() async {
    offlineModeOn = !offlineModeOn;
    if (offlineModeOn) {
      realm.syncSession.pause();
    } else {
      try {
        isWaiting = true;
        notifyListeners();
        realm.syncSession.resume();
        await updateSubscriptions();
      } finally {
        isWaiting = false;
      }
    }
    notifyListeners();
  }

  Future<void> switchSubscription(bool value) async {
    showAll = value;
    if (!offlineModeOn) {
      try {
        isWaiting = true;
        notifyListeners();
        await updateSubscriptions();
      } finally {
        isWaiting = false;
      }
    }
    notifyListeners();
  }

  void createItem(String summary, bool isComplete) {
    final newItem =
        Item(ObjectId(), summary, currentUser!.id, isComplete: isComplete);
    realm.write<Item>(() => realm.add<Item>(newItem));
    notifyListeners();
  }

  Future<void> createProducto(String detalle, double cantidad) async {
    final config = Configuration.flexibleSync(currentUser!, [Producto.schema]);
    final realm2 = Realm(config);

  realm2.subscriptions.update((mutableSubscriptions) {
    mutableSubscriptions.add(realm2.all<Producto>());
  });

  await realm2.subscriptions.waitForSynchronization();
  final newProducto = Producto(ObjectId(), detalle, currentUser!.id, cantidad);
  realm2.write(() {
    realm2.add(newProducto);
  });

    // final newProducto = Producto(ObjectId(), detalle, currentUser!.id, cantidad);
    // realm.write<Producto>(() => realm.add<Producto>(newProducto));
    notifyListeners();
  }

  void deleteItem(Item item) {
    realm.write(() => realm.delete(item));
    notifyListeners();
  }

  void deleteProducto(Producto producto) {
    realm.write(() => realm.delete(producto));
    notifyListeners();
  }

  Future<void> updateItem(Item item,
      {String? summary, bool? isComplete}) async {
    realm.write(() {
      if (summary != null) {
        item.summary = summary;
      }
      if (isComplete != null) {
        item.isComplete = isComplete;
      }
    });
    notifyListeners();
  }

  Future<void> updateProduct(Producto product, String? productName, double? stock) async {
    realm.write(() {
      if (productName != null) {
        product.productName = productName;
      }
      if (stock != null) {
        product.stock = stock;
      }
    });
    notifyListeners();
  }

  Future<void> close() async {
    if (currentUser != null) {
      await currentUser?.logOut();
      currentUser = null;
    }
    realm.close();
  }

  @override
  void dispose() {
    realm.close();
    super.dispose();
  }
}
