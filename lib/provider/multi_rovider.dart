import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_task/provider/screen_provider.dart';
final cart=ChangeNotifierProvider((ref) => CartProvider());