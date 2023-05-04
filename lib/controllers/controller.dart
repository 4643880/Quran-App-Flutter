
import 'package:get/get.dart';


class MyController extends GetxController{
  // final RxList<int> _ayahsIdList = <int>[].obs;
  //
  // setAddSelected(int id){
  //   _ayahsIdList.value.add(id);
  //   update();
  // }
  //
  // List<int> get selectedAyahsList => _ayahsIdList.value;

  final List<int> _ayahsIdList2 = [];
  void setAddSelected2(int id){
    _ayahsIdList2.add(id);
    update();
  }
  List<int> get selectedAyahsList2 => _ayahsIdList2;



}