import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_customer/app/core/models/time_model.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../profile_store.dart';
import 'profile_data_tile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileStore store = Modular.get();
  final genderKey = GlobalKey();
  final bankKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final LayerLink genderLayerLink = LayerLink();
  final LayerLink bankLayerLink = LayerLink();

  late OverlayEntry genderOverlay;
  late OverlayEntry bankOverlay;
  late OverlayEntry loadOverlay;

  FocusNode fullnameFocus = FocusNode();
  FocusNode birthdayFocus = FocusNode();
  FocusNode cpfFocus = FocusNode();
  FocusNode rgFocus = FocusNode();
  FocusNode issuerFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode usernameFocus = FocusNode();

  late final oldProfile;

  @override
  void initState() {
    oldProfile = store.profileEdit;
    // store.setProfileEditFromDoc();
    addGenderFocusListener();
    addBirthdayFocusListener();
    super.initState();
  }

  @override
  void dispose() {
    store.bytesAvatar = null;
    store.avatarFileName = null;
    if (store.confirmCodeOverlay != null && store.confirmCodeOverlay!.mounted) {
      store.confirmCodeOverlay!.remove();
    }

    fullnameFocus.dispose();
    birthdayFocus.removeListener(() {});
    birthdayFocus.dispose();
    cpfFocus.dispose();
    rgFocus.dispose();
    issuerFocus.dispose();
    genderFocus.removeListener(() {});
    genderFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    usernameFocus.dispose();

    super.dispose();
  }

  Future scrollToGender() async {
    final _context = genderKey.currentContext;
    double proportion = hXD(73, context) / maxWidth(context);

    await Scrollable.ensureVisible(_context!,
        alignment: proportion, duration: Duration(milliseconds: 400));
  }

  Future scrollToBank() async {
    final _context = bankKey.currentContext;
    double proportion = hXD(73, context) / maxWidth(context);

    await Scrollable.ensureVisible(_context!,
        alignment: proportion, duration: Duration(milliseconds: 400));
  }

  addGenderFocusListener() {
    genderFocus.addListener(() async {
      if (genderFocus.hasFocus) {
        scrollToGender();
        genderOverlay = getGenderOverlay();
        Overlay.of(context)!.insert(genderOverlay);
      } else {
        genderOverlay.remove();
      }
    });
  }

  addBirthdayFocusListener() {
    birthdayFocus.addListener(() async {
      if (birthdayFocus.hasFocus) {
        await store.setBirthday(context, () => cpfFocus.requestFocus());
      }
    });
  }

  OverlayEntry getGenderOverlay() {
    List<String> genders = ["Feminino", "Masculino", "Outro"];
    return OverlayEntry(
      builder: (context) => Positioned(
        height: wXD(100, context),
        width: wXD(80, context),
        child: CompositedTransformFollower(
          offset: Offset(wXD(35, context), wXD(60, context)),
          link: genderLayerLink,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   topRight: Radius.circular(30),
                //   bottomLeft: Radius.circular(30),
                // ),
                color: getColors(context).surface,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: Offset(0, 3),
                      color: getColors(context).shadow)
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: genders
                    .map(
                      (gender) => InkWell(
                        onTap: () {
                          store.profileEdit['gender'] = gender;
                          genderFocus.unfocus();
                        },
                        child: Container(
                          height: wXD(20, context),
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            gender,
                            style: textFamily(context),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        'xxxxxxxxxxxxxxxxxxx editProfile ${FirebaseAuth.instance.currentUser!.providerData[0].providerId}');
    return WillPopScope(
      onWillPop: () async {
        print("dateOverlay != null: ${dateOverlay != null}");
        if (store.loadCircularCode) {
          return false;
        }
        if (dateOverlay != null) {
          dateOverlay!.remove();
          dateOverlay = null;
          return false;
        } else {
          store.profileEdit = oldProfile;
          return true;
        }
      },
      child: Listener(
        onPointerDown: (event) =>
            FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              Observer(
                builder: (context) {
                  if (store.profileEdit.isEmpty) {
                    return CenterLoadCircular();
                  }
                  return SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  viewPaddingTop(context) + wXD(60, context)),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 3,
                                        offset: Offset(0, 3),
                                        color: getColors(context).shadow)
                                  ],
                                ),
                                child: ClipRRect(
                                  child: Container(
                                    height: wXD(338, context),
                                    width: maxWidth(context),
                                    child: store.bytesAvatar != null ? 
                                    Image.memory(
                                      store.bytesAvatar!,
                                      height: wXD(338, context),
                                      width: maxWidth(context),
                                      fit: BoxFit.fitWidth,
                                    ) :
                                    store.profileEdit['avatar'] == null ? 
                                      Image.asset(
                                        "./assets/images/defaultUser.png",
                                        height: wXD(338, context),
                                        width: maxWidth(context),
                                        fit: BoxFit.fitWidth,
                                      ) : 
                                      CachedNetworkImage(
                                        imageUrl: store.profileEdit['avatar'],
                                        height: wXD(338, context),
                                        width: maxWidth(context),
                                        fit: BoxFit.fitWidth,
                                        progressIndicatorBuilder:(context, value, downloadProgress) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: getColors(context).primary,
                                            ),
                                          );
                                        },
                                      ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: wXD(30, context),
                                right: wXD(17, context),
                                child: InkWell(
                                  onTap: () => store.pickAvatar(),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: veryLightGrey,
                                    size: wXD(30, context),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Visibility(
                            visible: store.avatarValidate,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: wXD(24, context),
                                  top: wXD(15, context)),
                              child: Text(
                                "Selecione uma imagem para continuar",
                                style: TextStyle(
                                  color: Colors.red[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: wXD(23, context), top: wXD(21, context)),
                            child: Text(
                              'Dados pessoais',
                              style: textFamily(
                                context,
                                fontSize: 16,
                                color: getColors(context).primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ProfileDataTile(
                            title: 'Nome completo',
                            data: store.profileEdit['fullname'],
                            hint: 'Fulano Ciclano',
                            focusNode: fullnameFocus,
                            onComplete: () => usernameFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['fullname'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Nome de usuário',
                            data: store.profileEdit['username'],
                            hint: 'Fulano',
                            focusNode: usernameFocus,
                            onComplete: () => birthdayFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['username'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Data de nascimento',
                            hint: '99/99/9999',
                            data: store.profileEdit['birthday'] != null
                                ? Time(store.profileEdit['birthday'].toDate())
                                    .dayDate()
                                : null,
                            onPressed: () => birthdayFocus.requestFocus(),
                            focusNode: birthdayFocus,
                            validate: store.birthdayValidate,
                          ),
                          ProfileDataTile(
                            title: 'CPF',
                            hint: '999.999.999-99',
                            textInputType: TextInputType.number,
                            data: cpfMask
                                .maskText(store.profileEdit['cpf'] ?? ''),
                            mask: cpfMask,
                            length: 11,
                            focusNode: cpfFocus,
                            onComplete: () => rgFocus.requestFocus(),
                            onChanged: (txt) => store.profileEdit['cpf'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'RG',
                            hint: '999.999.99',
                            // data:
                            //     rgMask.maskText(store.profileEdit['rg'] ?? ''),
                            data: store.profileEdit['rg'] ?? '',
                            // length: 8,
                            textInputType: TextInputType.number,
                            // mask: rgMask,
                            focusNode: rgFocus,
                            onComplete: () => issuerFocus.requestFocus(),
                            onChanged: (txt) => store.profileEdit['rg'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'Órgão emissor',
                            hint: 'SSP',
                            inputFormatter: UpperCaseTextFormatter(),
                            data: store.profileEdit['issuing_agency'],
                            focusNode: issuerFocus,
                            onComplete: () => emailFocus.requestFocus(),
                            onChanged: (txt) =>
                                store.profileEdit['issuing_agency'] = txt,
                          ),
                          ProfileDataTile(
                            title: 'E-mail',
                            hint: 'fulano@gmail.com',
                            data: store.profileEdit['email'],
                            focusNode: emailFocus,
                            onComplete: () => genderFocus.requestFocus(),
                            onChanged: (String? txt) =>
                                store.profileEdit['email'] = txt,
                            validator: (String? value) {
                              bool emailValid = RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(value!);

                              if (!emailValid) {
                                return 'Digite um e-mail válido';
                              } else {
                                return null;
                              }
                            },
                          ),
                          ProfileDataTile(
                            enabled: false,
                            title: 'Telefone',
                            hint: '+55 (99) 99999-9999',
                            data: phoneMask
                                .maskText(store.profileEdit['phone'] ?? ''),
                            mask: phoneMask,
                            focusNode: phoneFocus,
                            onComplete: () => genderFocus.requestFocus(),
                            length: 13,
                            onChanged: (String? txt) {
                              store.profileEdit['phone'] = txt;
                              print('phone $txt');
                            },
                          ),
                          CompositedTransformTarget(
                            link: genderLayerLink,
                            child: ProfileDataTile(
                              key: genderKey,
                              title: 'Gênero',
                              hint: 'Feminino',
                              data: store.profileEdit['gender'],
                              focusNode: genderFocus,
                              validate: store.genderValidate,
                              onPressed: () {
                                print("Render press");
                                genderFocus.requestFocus();
                              },
                            ),
                          ),
                          SizedBox(height: wXD(15, context)),
                          SideButton(
                            onTap: () async {
                              bool _validate = store.getValidate();
                              print('_validate : $_validate');
                              if (_formKey.currentState!.validate() &&
                                  _validate) {
                                Map result = await store.saveProfile(context);
                                print('rrrrrrrrrrrrrrrrrrrrresult $result');
                                if (result['status'] != 'success') {
                                  store.updateAuthUser(
                                    context: context,
                                    editEmail: result['update_email'],
                                    editPhone: result['update_phone'],
                                  );
                                }
                              }
                            },
                            height: wXD(52, context),
                            width: wXD(142, context),
                            title: 'Salvar',
                          ),
                          SizedBox(height: wXD(20, context))
                        ],
                      ),
                    ),
                  );
                },
              ),
              DefaultAppBar(
                'Editar perfil',
                onPop: () {
                  print("dateOverlay != null: ${dateOverlay != null}");
                  if (dateOverlay != null) {
                    dateOverlay!.remove();
                    dateOverlay = null;
                    return;
                  } else {
                    store.profileEdit = oldProfile;
                    Modular.to.pop();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SavingsCNPJ extends StatelessWidget {
  final ProfileStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: wXD(26, context),
        top: wXD(16, context),
        bottom: wXD(33, context),
      ),
      alignment: Alignment.centerLeft,
      child: Observer(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta é uma conta poupança?',
                style: textFamily(context, color: black.withOpacity(.6)),
              ),
              SizedBox(height: wXD(10, context)),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () => store.profileEdit['savings_account'] = true,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(right: wXD(9, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['savings_account']
                          ? Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Text(
                    'Sim',
                    style: textFamily(context, color: black.withOpacity(.6)),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () => store.profileEdit['savings_account'] = false,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(
                          right: wXD(9, context), left: wXD(15, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['savings_account']
                          ? Container()
                          : Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    'Não',
                    style: textFamily(context, color: black.withOpacity(.6)),
                  ),
                ],
              ),
              SizedBox(height: wXD(24, context)),
              Text(
                'Esta conta bancária está vinculada ao CNPJ da \nloja?',
                style: textFamily(context, color: black.withOpacity(.6)),
              ),
              SizedBox(height: wXD(10, context)),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () => store.profileEdit['linked_to_cnpj'] = true,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(right: wXD(9, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['linked_to_cnpj']
                          ? Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Text(
                    'Sim',
                    style: textFamily(context, color: black.withOpacity(.6)),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () => store.profileEdit['linked_to_cnpj'] = false,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(
                          right: wXD(9, context), left: wXD(15, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: getColors(context).primary,
                            width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['linked_to_cnpj']
                          ? Container()
                          : Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColors(context).primary,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    'Não',
                    style: textFamily(context, color: black.withOpacity(.6)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
