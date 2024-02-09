class ExceptionHandlingProvider { 

  ExceptionHandlingProvider(status){
    httpStatus = status;
  }

  int httpStatus = -1;
  String errorStatus = '';
  String errorMessage = '';

  Map<String, dynamic> generateExceptionResponse(){
    if(httpStatus == 400) {
      errorStatus = 'Bad Request';
      errorMessage = 'Invalid or malformed request';
    } else if(httpStatus == 401) {
      errorStatus = 'Unauthorized';
      errorMessage = 'Client does not have the required credentials to access resource';
    } else if(httpStatus == 402) {
      errorStatus = 'Payment Required';
      errorMessage = 'The request cannot be completed until a payment is made';
    } else if(httpStatus == 403) {
      errorStatus = 'Forbidden';
      errorMessage = 'Client does not have the required permissions to access resource';
    } else if(httpStatus == 404) {
      errorStatus = 'Not Found';
      errorMessage = 'The resource could not be found';
    } else if(httpStatus == 405) {
      errorStatus = 'Method Not Allowed';
      errorMessage = 'The HTTP method used on the resource is not allowed';
    } else if(httpStatus == 409) {
      errorStatus = 'Conflict';
      errorMessage = 'The request conflicts with the current state of the resource';
    } else if(httpStatus == 418) {
      errorStatus = 'I\'m A Teapot';
      errorMessage = 'The current version of the API is unsupported, please upgrade your request format';
    } else if(httpStatus == 422) {
      errorStatus = 'Unprocessable Entity';
      errorMessage = 'Request was well-formed but was unable to be followed due to semantic errors';
    } else if(httpStatus == 429) {
      errorStatus = 'Too Many Requests';
      errorMessage = 'Client is making too many requests in a short period of time';
    }

    return {
      'httpStatus': httpStatus,
      'errorStatus': errorStatus,
      'errorMessage': errorMessage
    };
  }
}