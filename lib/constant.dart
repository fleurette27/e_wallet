const String baseURL = 'http://10.0.2.2:8000/api';
// const String baseURL = 'http://127.0.0.1:8000/api';


const String loginURL = '$baseURL/login';
const String registerURL = '$baseURL/register';
const String logoutURL = '$baseURL/logout';
const String userURL = '$baseURL/user';
const String updateNameURL = '$baseURL/user/name';
const String updatePasswordURL = '$baseURL/user/password';
const String updateEmailURL = '$baseURL/user/email';
const String updatePhoneNumberURL = '$baseURL/user/phone-number';
const String transactionURL = '$baseURL/transactions';
const String recenteTransactionURL = '$baseURL/recenteTransactions';
const String depositURL = '$baseURL/depot';
const String withdrawalURL = '$baseURL/retrait';
const String transferURL = '$baseURL/transfert';
const String fedaTransferURL = '$baseURL/feda/depot';

// ----- Errors -----
const String serverError = 'Erreur du serveur';
const String unauthorized = 'Non autorisé';
const String somethingWentWrong = 'Quelque chose s\'est mal passé, veuillez réessayer!';
