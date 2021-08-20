abstract class SignupStates {}

class SignupInitialState extends SignupStates{}

class SignupLoadingState extends SignupStates{}

class SignupErrorState extends SignupStates{
  final String error;

  SignupErrorState(this.error);
}

class CreateUserAndSignupSuccessState extends SignupStates {
  final String uid;
  CreateUserAndSignupSuccessState({
    required this.uid});

}

class CreateUserErrorState extends SignupStates {
  final String error;
  CreateUserErrorState({
    required this.error,
  });

}

class SignupChangePasswordVisibility extends SignupStates{}