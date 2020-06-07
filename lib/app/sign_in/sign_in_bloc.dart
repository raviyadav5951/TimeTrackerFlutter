import 'dart:async';

//These steps 1-4 are required in every Bloc
class SignInBloc{

  //step1
  final StreamController<bool> _isLoadingController=new StreamController<bool>();

  //step2
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  //step3 add in stream
  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  //step 4 dispose
  void dispose() => _isLoadingController.close();
}