import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_y_registro/common/tema_principal.dart';
import 'package:login_y_registro/pages/widgets/header_widget.dart';
import 'package:login_y_registro/negocio/regController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'menu_y_usuario.dart';

//flutter run -d chrome --web-port=8080 --web-hostname=127.0.0.1

class RegistroCaballos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistroCaballos();
  }
}

class _RegistroCaballos extends State<RegistroCaballos> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nombrectrl = new TextEditingController();
  TextEditingController apellidoctrl = new TextEditingController();
  TextEditingController celularctrl = new TextEditingController();

  TextEditingController emailctrl = new TextEditingController();
  TextEditingController contrasenactrl = new TextEditingController();

  TextEditingController direccionctrl = new TextEditingController();
  TextEditingController ciudadctrl = new TextEditingController();

  bool checkedValue = false;
  bool checkboxValue = false;
  bool NexistImage = true;

  final ctrReg = regController();

  final ImagePicker _picker = ImagePicker();
  File? image;
  late Uint8List webImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: NexistImage
                              ? Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding:
                                EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          )
                              : Container(
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              backgroundImage: MemoryImage(webImage),
                              radius: 80,
                            ),
                          ),
                          onTap: () async {
                            XFile? temp = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (temp != null) {
                              var f = await temp.readAsBytes();
                              setState(() {
                                webImage = f;
                                if (NexistImage) {
                                  NexistImage = !NexistImage;
                                }
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: nombrectrl,
                            decoration: TemaPrincipal().textInputDecoration(
                                'Nombre del equino', 'Ingrese el nombre del caballo'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Ingrese los datos solicitados";
                              }
                              return null;
                            },
                          ),
                          decoration:
                          TemaPrincipal().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        Container(
                          child: TextFormField(
                            controller: direccionctrl,
                            decoration: TemaPrincipal().textInputDecoration(
                                'Cuadrilla/Box del caballo',
                                'Ingrese la ubicación del caballo'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Ingrese los datos solicitados";
                              }
                              return null;
                            },
                          ),

                          decoration:
                          TemaPrincipal().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: ciudadctrl,
                            decoration: TemaPrincipal().textInputDecoration(
                                'Edad del animal',
                                'Ingrese la fecha de nacimiento del caballo'),

                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Ingrese los datos solicitados";
                              }
                              return null;
                            },
                          ),
                          decoration:
                          TemaPrincipal().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                    Container(
                          decoration:
                          TemaPrincipal().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: TemaPrincipal().buttonStyle(),
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Registrar caballo".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var res = await ctrReg.verificar(
                                    emailctrl.text, contrasenactrl.text);

                                if (res == 1) {
                                  var id = "125";
                                  ctrReg.insertarPersona(nombrectrl.text,
                                      apellidoctrl.text, celularctrl.text, id);
                                  ctrReg.insertarUsuario(
                                      emailctrl.text, contrasenactrl.text, id);
                                  ctrReg.insertarUbicacion(
                                      ciudadctrl.text, direccionctrl.text, id);

                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => MenuYUsuario()),
                                          (Route<dynamic> route) => false);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                      "Los datos concuerdan con los de un caballo ya registrado",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      webPosition: "center",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 50,
                                      timeInSecForIosWeb: 2);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Future<XFile?> filePicker() async {
//  final XFile? imageFile =
//     await _picker.pickImage(source: ImageSource.gallery);
// return imageFile;
//}
}