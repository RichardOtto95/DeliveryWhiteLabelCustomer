import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/customer_model.dart';
import 'package:delivery_customer/app/core/services/auth/auth_service_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService implements AuthServiceInterface {
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future handleFacebookSignin() {
    return Future(() {});
  }

  @override
  Future<String> handleGetToken() {
    return Future(() => '');
  }

  @override
  handleGetUser() async {
    return Future(() => _auth.currentUser!);
  }

  @override
  Future<User> handleEmailSignin(String userEmail, String userPassword) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: userEmail, password: userPassword);
    final User? user = result.user!;

    assert(user != null);
    // assert(await user!.getIdToken() != null);

    final User currentUser = _auth.currentUser!;
    assert(user!.uid == currentUser.uid);

    //print'signInEmail succeeded: $user');

    return user!;
  }

  @override
  Future<Customer> handleSignup() async {
    print('%%%%%%%% handleSignup %%%%%%%%');

    User user = _auth.currentUser!;
    await user.reload();
    // await user.sendEmailVerification();
    // showToast(
    //     'Um e-mail de verificação foi enviado para a sua caixa de entrada');

    // String token = await FirebaseMessaging.instance.getToken();
    // print('tokenId: $token');
    // print('user criar : ${user.uid}');
    Customer customer = Customer();
    customer.id = user.uid;
    customer.createdAt = Timestamp.now();
    customer.username =
        user.phoneNumber != null ? user.phoneNumber : user.email;
    customer.notificationEnabled = true;
    customer.phone = user.phoneNumber;
    customer.email = user.email;
    customer.status = 'ACTIVE';
    customer.connected = true;
    customer.country = 'Brasil';
    customer.accountBalance = 0;
    customer.userPromotionalCode = user.uid.substring(0, 8);
    String? tokenString = await FirebaseMessaging.instance.getToken();
    customer.tokenId = [tokenString!];

    Map<String, dynamic> customerMap = Customer().toJson(model: customer);
    print('customerMap: $customerMap');

    DocumentReference cusRef =
        FirebaseFirestore.instance.collection('customers').doc(user.uid);

    await cusRef.set(customerMap);

    return customer;
  }

  @override
  Future<User> handleLinkAccountGoogle(User _user) async {
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    User user = _user;

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // user = (await _user.linkWithCredential(credential)).user;
    // //print"signed in " + user.displayName);
    // Firestore.instance
    //     .collection('users')
    //     .document(user.uid)
    //     .updateData({'firstName': user.displayName, 'email': user.email});
    // // var credentialResult = await _auth.signInWithCredential(credential);
    // // user.linkWithCredential(credential);
    return user;
  }

  @override
  handleGoogleSignin() async {
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    User? user;
    // if (user== null) throw Exception();

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );
    // List<String> providers =
    //     await _auth.fetchSignInMethodsForEmail(email: googleUser.email);
    // //print'providers: $providers');
    // if (providers != null) {
    //   //print"TEM PROV  $user");
    //   user = (await _auth.signInWithCredential(credential)).user;

    //   user.linkWithCredential(credential);
    //   //print"TEM PROV  $user");
    // } else {
    //   user = (await _auth.signInWithCredential(credential)).user;
    //   //print"signed in " + user.displayName);
    //   //print"NAO TEM PROV  $user");
    // }
    // user = (await _auth.signInWithCredential(credential)).user;
    // //print"signed in " + user.displayName);
    // var credentialResult = await _auth.signInWithCredential(credential);
    // user.linkWithCredential(credential);
    return user!;
  }

  @override
  Future handleSetSignout() {
    return _auth.signOut();
  }

  @override
  Future<String> verifyNumber(String userPhone) async {
    String? verifID;
    var phoneMobile = userPhone;
    //print'$phoneMobile');

    await _auth
        .verifyPhoneNumber(
      phoneNumber: phoneMobile,
      verificationCompleted: (AuthCredential authCredential) async {
        //code for signing in}).catchError((e){
        // final User user =
        //     (await _auth.signInWithCredential(authCredential)).user;
        _auth
            .signInWithCredential(authCredential)
            .then((UserCredential result) {
          //print'AuthResult ${result.user}');
        }).catchError((e) {
          //print'ERROR !!! $e');
        });
        // //print'verifyPhoneNumber $e}');
      },
      verificationFailed: (FirebaseAuthException authException) {
        // //printauthException.message);
        //print'ERROR !!! ${authException.message}');
      },
      codeSent: (verificationId, forceResendingToken) {
        verificationId = verificationId;
        verifID = verificationId;
        print("Código enviado para " + userPhone);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        //printverificationId);
        //print"Timout");
      },
      timeout: Duration(seconds: 60),
    )
        .catchError((e) {
      //print'ERROR !!! $e');
    });
    return verifID!;
  }

  @override
  Future<User> handleSmsSignin(String smsCode, String verificationId) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    final User user = (await _auth.signInWithCredential(credential)).user!;

    return user;
  }
}
