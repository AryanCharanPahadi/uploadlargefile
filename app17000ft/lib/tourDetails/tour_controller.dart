import 'package:app17000ft/helper/database_helper.dart';
import 'package:app17000ft/tourDetails/tour_model.dart';
import 'package:get/get.dart';

class TourController extends GetxController {
  List<TourDetails> localTourList = [];
  List<TourDetails> get getLocalTourList => localTourList;
 

  void initState() {
    super.onInit();
   
  }

  fetchTourDetails() async {
  

    localTourList = await LocalDbController().fetchLocalTourDetails();
    print('this is localtour list $localTourList');

    
    update();
  }
}
