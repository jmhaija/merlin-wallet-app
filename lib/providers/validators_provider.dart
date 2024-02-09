var emailValid = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
var userValid = RegExp('^(?=.{6,})[a-z]+(?:[a-z0-9_]+)*\$');
//password pattern:  accept minimum 10 characters & at least one letter & at least one number
var passValid = RegExp('^(?=.{10,}\$)(?=.*[A-Z])?(?=.*[a-z])(?=.*[0-9])+(?=.*[!@#\$%^&*(),.?:{}|<>])?.*');
var nameFormat = RegExp(r'^[0-9A-Za-z\s\-]+$');

class ValidatorProvider {
  bool checkEmailValidation(email) {
    return emailValid.hasMatch(email) ? true : false;
  }

  bool checkUsernameValidation(username) {
    return userValid.hasMatch(username) ? true : false;
  }

  bool checkPasswordValidation(password) {
    return passValid.hasMatch(password) ? true : false;
  }

  bool checkNameValidation(name) {
    return nameFormat.hasMatch(name) ? true : false;
  }
}
