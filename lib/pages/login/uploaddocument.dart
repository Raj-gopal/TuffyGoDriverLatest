import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import 'requiredinformation.dart';

// ignore: must_be_immutable
class UploadDocument extends StatefulWidget {
  dynamic fleetid;
  UploadDocument({Key? key, this.fleetid}) : super(key: key);

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

int docsId = 0;
int choosenDocs = 0;

String docIdNumber = '';
String date = '';
DateTime expDate = DateTime.now();
// final ImagePicker _picker = ImagePicker();
dynamic imageFile;

class _UploadDocumentState extends State<UploadDocument> {
  bool _isLoading = true;

// dynamic imageFile;

  @override
  void initState() {
    getDocument();
    super.initState();
  }

  getDocument() async {
    // if (widget.fleetid == null) {
    await getDocumentsNeeded();
    // }
    // else {
    //   await getFleetDocumentsNeeded(widget.fleetid);
    // }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Stack(
          children: [
            Container(
              height: media.height * 1,
              width: media.width * 1,
              color: Colors.black,
              padding: EdgeInsets.only(
                  left: media.width * 0.05, right: media.width * 0.05),
              child: Column(
                children: [
                  SizedBox(
                    height:
                        media.width * 0.05 + MediaQuery.of(context).padding.top,
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: media.width * 0.05),
                        width: media.width * 1,
                        alignment: Alignment.center,
                        child: MyText(
                            text: languages[choosenLanguage]['text_docs'],
                            size: media.width * fourteen),
                      ),
                      Positioned(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (enableDocumentSubmit == true) {
                                    documentCompleted = true;
                                  } else {
                                    documentCompleted = false;
                                  }
                                  Navigator.pop(context, true);
                                },
                                child: Icon(Icons.arrow_back_ios,
                                    color: textColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  SizedBox(
                    width: media.width * 0.9,
                    child: MyText(
                      text: languages[choosenLanguage]['text_docs']
                          .toString()
                          .toUpperCase(),
                      size: media.width * fourteen,
                      fontweight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  if (documentsNeeded.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: documentsNeeded
                              .asMap()
                              .map((i, value) {
                                return MapEntry(
                                    i,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text: documentsNeeded[i]['name'],
                                          size: media.width * fourteen,
                                          fontweight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: media.width * 0.02,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            docsId = documentsNeeded[i]['id'];
                                            choosenDocs = i;
                                            // docsData = (documentsNeeded[i]['driver_document'] != null) ? documentsNeeded[i]['driver_document']['data'] : {};
                                            // ignore: unused_local_variable
                                            var nav = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DocumentUpload(
                                                            from:
                                                                (widget.fleetid ==
                                                                        null)
                                                                    ? 'normal'
                                                                    : 'fleet')));
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: media.width * 0.9,
                                            height: media.width * 0.165,
                                            padding: EdgeInsets.only(
                                                left: media.width * 0.02,
                                                right: media.width * 0.02),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: (isDarkTheme == true)
                                                        ? textColor
                                                            .withOpacity(0.4)
                                                        : textColor,
                                                    width: 1),
                                                color: (isDarkTheme == true)
                                                    ? Colors.black
                                                    : const Color(0xffF8F8F8)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  (documentsNeeded[i]
                                                              ['is_uploaded'] ==
                                                          false)
                                                      ? MainAxisAlignment.center
                                                      : MainAxisAlignment
                                                          .spaceBetween,
                                              children: [
                                                (documentsNeeded[i]
                                                            ['is_uploaded'] ==
                                                        true)
                                                    ? Container(
                                                        height:
                                                            media.width * 0.1,
                                                        width:
                                                            media.width * 0.1,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    documentsNeeded[i]['driver_document']['data']
                                                                            [
                                                                            'document']
                                                                        .toString(),
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                      )
                                                    : Container(),
                                                (documentsNeeded[i]
                                                            ['is_uploaded'] ==
                                                        true)
                                                    ? SizedBox(
                                                        width:
                                                            media.width * 0.5,
                                                        child: MyText(
                                                          text: documentsNeeded[
                                                                      i][
                                                                  'document_status_string']
                                                              .toString(),
                                                          size: media.width *
                                                              fourteen,
                                                          textAlign:
                                                              TextAlign.center,
                                                          color: Colors.red,
                                                        ),
                                                      )
                                                    : Container(),
                                                Icon(
                                                  (documentsNeeded[i]
                                                              ['is_uploaded'] ==
                                                          false)
                                                      ? Icons.cloud_upload
                                                      : Icons.done_outlined,
                                                  color: textColor,
                                                  size: media.width * 0.06,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (documentsNeeded[i]
                                                ['driver_document'] !=
                                            null)
                                          if (documentsNeeded[i]
                                                      ['driver_document']
                                                  ['data']['comment'] !=
                                              null)
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: media.width * 0.02),
                                              width: media.width * 0.9,
                                              child: MyText(
                                                text: documentsNeeded[i]
                                                            ['driver_document']
                                                        ['data']['comment']
                                                    .toString(),
                                                size: media.width * fourteen,
                                                textAlign: TextAlign.center,
                                                color: Colors.red,
                                              ),
                                            ),
                                        SizedBox(
                                          height: media.width * 0.08,
                                        ),
                                      ],
                                    ));
                              })
                              .values
                              .toList(),
                        ),
                      ),
                    ),
                  if (enableDocumentSubmit == true)
                    Column(
                      children: [
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Button(
                            onTap: () {
                              documentCompleted = true;
                              Navigator.pop(context, true);
                            },
                            text: languages[choosenLanguage]['text_submit']),
                        SizedBox(
                          height: media.width * 0.05,
                        )
                      ],
                    )
                ],
              ),
            ),
            if (_isLoading == true)
              const Positioned(
                child: Loading(),
              )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DocumentUpload extends StatefulWidget {
  String from;
  DocumentUpload({Key? key, required this.from}) : super(key: key);

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  TextEditingController idNumber = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  DateTime current = DateTime.now();
  String _permission = '';
  bool _uploadImage = false;
  bool _isLoading = false;
  String _error = '';

  //date picker
  _datePicker() async {
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: current,
        firstDate: current,
        lastDate: DateTime(2100));
    if (picker != null) {
      setState(() {
        expDate = picker;
        date = picker.toString().split(" ")[0];
      });
    }
  }

//get gallery permission

  getGalleryPermission() async {
    dynamic status;
    if (platform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
        }

        /// use [Permissions.storage.status]
      } else {
        status = await Permission.photos.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.photos.request();
        }
      }
    } else {
      status = await Permission.photos.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.photos.request();
      }
    }
    return status;
  }

//get camera permission
  getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status;
  }

//image pick from gallery
  imagePick() async {
    var permission = await getGalleryPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      setState(() {
        imageFile = pickedFile?.path;
        _uploadImage = false;
      });
    } else {
      setState(() {
        _permission = 'noPhotos';
      });
    }
  }

//image pick from camera
  cameraPick() async {
    var permission = await getCameraPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      setState(() {
        imageFile = pickedFile?.path;
        _uploadImage = false;
      });
    } else {
      setState(() {
        _permission = 'noCamera';
      });
    }
  }

  @override
  void initState() {
    date = '';
    imageFile = null;
    docIdNumber = '';

    super.initState();
  }

  pop() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Scaffold(
        body: Directionality(
            textDirection: (languageDirection == 'rtl')
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Stack(
              children: [
                Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  padding: EdgeInsets.only(
                      left: media.width * 0.05, right: media.width * 0.05),
                  color: Colors.black,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: media.width * 0.05 +
                                    MediaQuery.of(context).padding.top,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: media.width * 0.05),
                                    width: media.width * 1,
                                    alignment: Alignment.center,
                                    child: MyText(
                                        text: languages[choosenLanguage]
                                            ['text_upload_docs'],
                                        size: media.width * fourteen),
                                  ),
                                  Positioned(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(Icons.arrow_back_ios,
                                                color: textColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Stack(
                                children: [
                                  Container(
                                      height: media.width * 0.5,
                                      width: media.width * 0.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        // color: Colors.transparent.withOpacity(0.2),
                                      ),
                                      child: (imageFile != null)
                                          ? Container(
                                              height: media.width * 0.5,
                                              width: media.width * 0.5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image: FileImage(
                                                          File(imageFile)),
                                                      fit: BoxFit.contain)),
                                            )
                                          : Container()),
                                  Positioned(
                                      child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _uploadImage = true;
                                      });
                                    },
                                    child: Container(
                                      height: media.width * 0.5,
                                      width: media.width * 0.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white10,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.cloud_upload,
                                            size: media.width * 0.08,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          MyText(
                                              text: (imageFile == null)
                                                  ? languages[choosenLanguage]
                                                      ['text_upload_image']
                                                  : languages[choosenLanguage]
                                                      ['text_editimage'],
                                              size: media.width * twelve)
                                        ],
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                              if (documentsNeeded[choosenDocs]
                                      ['has_identify_number'] ==
                                  true)
                                Column(
                                  children: [
                                    SizedBox(
                                      height: media.height * 0.05,
                                    ),
                                    SizedBox(
                                      width: media.width * 0.9,
                                      child: MyText(
                                        text: documentsNeeded[choosenDocs]
                                                ['identify_number_locale_key']
                                            .toString(),
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.height * 0.02,
                                    ),
                                    Container(
                                        height: media.width * 0.13,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: (isDarkTheme == true)
                                                    ? textColor.withOpacity(0.4)
                                                    : underline),
                                            color: (isDarkTheme == true)
                                                ? Colors.black
                                                : const Color(0xffF8F8F8)),
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: MyTextField(
                                          textController: idNumber,
                                          hinttext: documentsNeeded[choosenDocs]
                                                  ['identify_number_locale_key']
                                              .toString(),
                                          onTap: (val) {
                                            setState(() {
                                              docIdNumber = val;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              if (documentsNeeded[choosenDocs]
                                      ['has_expiry_date'] ==
                                  true)
                                Column(
                                  children: [
                                    SizedBox(
                                      height: media.height * 0.05,
                                    ),
                                    SizedBox(
                                      width: media.width * 0.9,
                                      child: MyText(
                                        text: languages[choosenLanguage]
                                            ['text_expiry_date'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.height * 0.02,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _datePicker();
                                      },
                                      child: Container(
                                          height: media.width * 0.13,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: (isDarkTheme == true)
                                                      ? textColor
                                                          .withOpacity(0.4)
                                                      : underline),
                                              color: (isDarkTheme == true)
                                                  ? Colors.black
                                                  : const Color(0xffF8F8F8)),
                                          width: media.width * 0.9,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          alignment: Alignment.centerLeft,
                                          child: MyText(
                                            text: (date != '')
                                                ? date
                                                : languages[choosenLanguage]
                                                    ['text_choose_expiry'],
                                            size: media.width * fourteen,
                                          )),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        child: Column(
                          children: [
                            if (_error != '')
                              SizedBox(
                                width: media.width * 0.9,
                                child: MyText(
                                  text: _error,
                                  size: media.width * fourteen,
                                  color: Colors.red,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            Button(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    _isLoading = true;
                                    _error = '';
                                  });
                                  if (imageFile != null) {
                                    if (documentsNeeded[choosenDocs]
                                                ['has_identify_number'] ==
                                            true &&
                                        docIdNumber != '' &&
                                        documentsNeeded[choosenDocs]
                                                ['has_expiry_date'] ==
                                            true &&
                                        date != '') {
                                      var result = await uploadDocs();

                                      if (result == 'success') {
                                        var result = await getDocumentsNeeded();
                                        if (result == 'success') {
                                          pop();
                                        }
                                      } else {
                                        setState(() {
                                          _error = result.toString();
                                        });
                                      }
                                    } else if (documentsNeeded[choosenDocs]
                                                ['has_identify_number'] ==
                                            true &&
                                        docIdNumber != '' &&
                                        documentsNeeded[choosenDocs]
                                                ['has_expiry_date'] ==
                                            false) {
                                      var result = await uploadDocs();

                                      if (result == 'success') {
                                        var result = await getDocumentsNeeded();
                                        if (result == 'success') {
                                          pop();
                                        }
                                      } else {
                                        setState(() {
                                          _error = result.toString();
                                        });
                                      }
                                    } else if (documentsNeeded[choosenDocs]
                                                ['has_identify_number'] ==
                                            false &&
                                        documentsNeeded[choosenDocs]
                                                ['has_expiry_date'] ==
                                            true &&
                                        date != '') {
                                      var result = await uploadDocs();

                                      if (result == 'success') {
                                        var result = await getDocumentsNeeded();
                                        if (result == 'success') {
                                          pop();
                                        }
                                      } else {
                                        setState(() {
                                          _error = result.toString();
                                        });
                                      }
                                    } else if (documentsNeeded[choosenDocs]
                                                ['has_identify_number'] ==
                                            false &&
                                        documentsNeeded[choosenDocs]
                                                ['has_expiry_date'] ==
                                            false) {
                                      var result = await uploadDocs();

                                      if (result == 'success') {
                                        var result = await getDocumentsNeeded();
                                        if (result == 'success') {
                                          pop();
                                        }
                                      } else {
                                        setState(() {
                                          _error = result.toString();
                                        });
                                      }
                                    } else {
                                      _error = languages[choosenLanguage]
                                          ['text_fil_req_info'];
                                    }
                                  } else {
                                    _error = languages[choosenLanguage]
                                        ['text_choose_image'];
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                                text: languages[choosenLanguage]
                                    ['text_submit']),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //upload image popup
                (_uploadImage == true)
                    ? Positioned(
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _uploadImage = false;
                            });
                          },
                          child: Container(
                            height: media.height * 1,
                            width: media.width * 1,
                            color: Colors.transparent.withOpacity(0.6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(media.width * 0.05),
                                  width: media.width * 1,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25)),
                                      border: Border.all(
                                        color: borderLines,
                                        width: 1.2,
                                      ),
                                      color: page),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: media.width * 0.02,
                                        width: media.width * 0.15,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.01),
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  cameraPick();
                                                },
                                                child: Container(
                                                    height: media.width * 0.171,
                                                    width: media.width * 0.171,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: borderLines,
                                                            width: 1.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: media.width * 0.064,
                                                      color: textColor,
                                                    )),
                                              ),
                                              SizedBox(
                                                height: media.width * 0.02,
                                              ),
                                              MyText(
                                                text: languages[choosenLanguage]
                                                    ['text_camera'],
                                                size: media.width * ten,
                                                color: (isDarkTheme == true)
                                                    ? textColor.withOpacity(0.4)
                                                    : const Color(0xff666666),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  imagePick();
                                                },
                                                child: Container(
                                                    height: media.width * 0.171,
                                                    width: media.width * 0.171,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: borderLines,
                                                            width: 1.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                    child: Icon(
                                                      Icons.image_outlined,
                                                      size: media.width * 0.064,
                                                      color: textColor,
                                                    )),
                                              ),
                                              SizedBox(
                                                height: media.width * 0.02,
                                              ),
                                              MyText(
                                                text: languages[choosenLanguage]
                                                    ['text_gallery'],
                                                size: media.width * ten,
                                                color: (isDarkTheme == true)
                                                    ? textColor.withOpacity(0.4)
                                                    : const Color(0xff666666),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    : Container(),

                //permission denied error
                (_permission != '')
                    ? Positioned(
                        child: Container(
                        height: media.height * 1,
                        width: media.width * 1,
                        color: Colors.transparent.withOpacity(0.6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: media.width * 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _permission = '';
                                        _uploadImage = false;
                                      });
                                    },
                                    child: Container(
                                      height: media.width * 0.1,
                                      width: media.width * 0.1,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle, color: page),
                                      child: Icon(Icons.cancel_outlined,
                                          color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            Container(
                              padding: EdgeInsets.all(media.width * 0.05),
                              width: media.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: page,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2.0,
                                        spreadRadius: 2.0,
                                        color: Colors.black.withOpacity(0.2))
                                  ]),
                              child: Column(
                                children: [
                                  SizedBox(
                                      width: media.width * 0.8,
                                      child: MyText(
                                        text: (_permission == 'noPhotos')
                                            ? languages[choosenLanguage]
                                                ['text_open_photos_setting']
                                            : languages[choosenLanguage]
                                                ['text_open_camera_setting'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.w600,
                                      )),
                                  SizedBox(height: media.width * 0.05),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            await openAppSettings();
                                          },
                                          child: MyText(
                                            text: languages[choosenLanguage]
                                                ['text_open_settings'],
                                            size: media.width * sixteen,
                                            color: buttonColor,
                                            fontweight: FontWeight.w600,
                                          )),
                                      InkWell(
                                          onTap: () async {
                                            (_permission == 'noCamera')
                                                ? cameraPick()
                                                : imagePick();
                                            setState(() {
                                              _permission = '';
                                            });
                                          },
                                          child: MyText(
                                            text: languages[choosenLanguage]
                                                ['text_done'],
                                            size: media.width * sixteen,
                                            color: buttonColor,
                                            fontweight: FontWeight.w600,
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                    : Container(),
                if (_isLoading == true) const Positioned(child: Loading())
              ],
            )),
      ),
    );
  }
}
