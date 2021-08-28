

import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {

  @HiveField(0)
  late String name;

  @HiveField(3)
  late String director;



}
