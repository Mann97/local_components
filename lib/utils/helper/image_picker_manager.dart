import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_components/utils/extention/context_extension.dart';
import 'package:local_components/utils/extention/extension.dart';
import 'package:local_components/utils/helper/image_cropper_dialog.dart';
import 'package:local_components/utils/theme/app_colors.dart';
import 'package:local_components/utils/theme/text_style.dart';
import 'package:local_components/utils/widgets/common_button.dart';
import 'package:local_components/utils/widgets/common_dialogs.dart';
import 'package:local_components/utils/widgets/common_permission_widget.dart';
import 'package:permission_handler/permission_handler.dart';

/*
Required permissions for iOS
NSCameraUsageDescription :- ${PRODUCT_NAME} is require camera permission to choose user profile photo.
NSPhotoLibraryUsageDescription :- ${PRODUCT_NAME} is require photos permission to choose user profile photo.

Required permissions for Android
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA"/>

<!--Image Cropper-->
       <activity
           android:name="com.yalantis.ucrop.UCropActivity"
           android:exported="true"
           android:screenOrientation="portrait"
           android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
* */

class ImagePickerManager {
  ImagePickerManager._privateConstructor();

  static final ImagePickerManager instance = ImagePickerManager._privateConstructor();

  var imgSelectOption = {'camera', 'gallery', 'document', 'remove'};
  String selectionType = '';
  String cameraStorageAnim = '';
  String requestCameraAndStoragePermissionMsg = '';
  String requestPermission = '';

  /// Call this method for dynamic messages
  initMessages({required String cameraStorageAnim, required String requestCameraAndStoragePermissionMsg, required String requestPermission}) {
    this.cameraStorageAnim = cameraStorageAnim;
    this.requestCameraAndStoragePermissionMsg = requestCameraAndStoragePermissionMsg;
    this.requestPermission = requestPermission;
  }

  /*
  Open Picker
  Usage:- File? file = await ImagePickerManager.instance.openPicker(context);
  * */
  Future<Uint8List?> openPicker(BuildContext mainContext, {int? ratioX, int? ratioY}) async {
    String type = '';
    WebUiSettings webUiSettings = WebUiSettings(
        context: mainContext,
        enableResize: false,
        mouseWheelZoom: true,
        enableZoom: true,
        viewPort: CroppieViewPort(width: ratioX ?? 200, height: ratioY ?? 400, type: 'square'),
        showZoomer: false,
        barrierColor: AppColors.black.withOpacity(0.9),
        boundary: (mainContext.isMobileScreen)
            ? CroppieBoundary(
                width: (mainContext.width * 0.8).toInt(),
                height: (mainContext.height * 0.6).toInt(),
              )
            : null,
        customDialogBuilder: /*(mainContext.isMobileScreen)
          ?*/
            (cropper, crop, rotate) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: ImageCropperDialog(
                crop: crop,
                cropper: cropper,
                rotate: rotate,
                mainContext: mainContext,
                title: 'Crop Image',
              ),
            ),
          );
        }
        /*: null,*/
        );

    if (!kIsWeb) {
      await showModalBottomSheet(
          context: mainContext,
          backgroundColor: AppColors.transparent,
          barrierColor: AppColors.black.withOpacity(0.3),
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, state) {
              return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.black171717,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              )),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  type = imgSelectOption.elementAt(0);
                                  selectionType = imgSelectOption.elementAt(0);
                                  await checkPermissions(mainContext, permission: Permission.camera);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: context.height * 0.025, bottom: context.height * 0.02),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Take Photo',
                                    style: TextStyles.regular.copyWith(color: AppColors.white, fontSize: 18.sp),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: context.width * 0.02, right: context.width * 0.02),
                                child: Divider(height: 1, color: AppColors.greyBEBEBE.withOpacity(0.2)),
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  type = imgSelectOption.elementAt(1);
                                  selectionType = imgSelectOption.elementAt(1);
                                  await checkPermissions(mainContext, permission: Permission.photos);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: context.height * 0.02, bottom: context.height * 0.02),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Upload From Gallery',
                                    style: TextStyles.regular.copyWith(color: AppColors.white, fontSize: 18.sp),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: context.width * 0.02, right: context.width * 0.02),
                                child: Divider(height: 1, color: AppColors.greyBEBEBE.withOpacity(0.2)),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  type = imgSelectOption.elementAt(3);
                                  selectionType = imgSelectOption.elementAt(3);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: context.height * 0.02, bottom: context.height * 0.02),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Remove Profile Picture',
                                    style: TextStyles.regular.copyWith(color: AppColors.white, fontSize: 18.sp),
                                  ),
                                ),
                              ),
                              CommonButton(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                buttonText: 'Cancel',
                                buttonTextColor: AppColors.white,
                                buttonTextStyle: TextStyles.regular.copyWith(
                                  fontSize: 18.sp,
                                  color: AppColors.white,
                                ),
                                buttonEnabledColor: AppColors.blue,
                              ).paddingOnly(bottom: 15.h, left: context.width * 0.02, right: context.width * 0.025),
                            ],
                          ),
                        ).paddingOnly(
                          top: 30.h,
                        ),
                      )));
            });
          });
    } else {
      type = imgSelectOption.elementAt(1);
      selectionType = imgSelectOption.elementAt(1);
    }
    // Uint8List pickedImage = await ImagePicker().pickImage(source: source)

    Uint8List? pickedImage;
    XFile? fileProfile;
    if (type.isNotEmpty) {
      if (imgSelectOption.elementAt(3) == type) {
        fileProfile = null;
      } else {
        if (type != '') {
          fileProfile = (await ImagePicker().pickImage(source: (imgSelectOption.elementAt(0) == type) ? ImageSource.camera : ImageSource.gallery));
        }
      }
    }

    if (fileProfile != null && fileProfile.path != '') {
      CroppedFile? cropImage = await ImageCropper().cropImage(
        sourcePath: fileProfile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          webUiSettings,
        ],
      );

      if (cropImage != null && cropImage.path != '') {
        pickedImage = await cropImage.readAsBytes();
      }
    }

    return pickedImage;
  }

  Future checkPermissions(BuildContext context, {required Permission permission}) async {
    if (!kIsWeb) {
      if (await permission.status != PermissionStatus.granted) {
        await permission.request().then((permissionResult) {
          if (permissionResult.isPermanentlyDenied) {
            showWidgetDialog(
                context,
                CommonPermissionWidget(
                  onPositiveButtonTap: () async {
                    openAppSettings();
                  },
                  cameraStorageAnim: cameraStorageAnim,
                  requestCameraAndStoragePermissionMsg: requestCameraAndStoragePermissionMsg,
                  requestPermission: requestPermission,
                ),
                () => null);
          }
        });
      }
    }
  }

/*
  Open Multi Picker
  Usage:- Future<List<File>?> files = ImagePickerManager.instance.openMultiPicker(context);
  * */
// Future<List<File>?> openMultiPicker(BuildContext context,
//     {int maxAssets = 3}) async {
//   final List<AssetEntity>? result = await AssetPicker.pickAssets(
//     context,
//     pickerConfig: AssetPickerConfig(
//       maxAssets: maxAssets,
//       themeColor: AppColors.primary,
//       requestType: RequestType.image,
//     ),
//   );
//
//   List<File> files = [];
//   if ((result ?? []).isNotEmpty) {
//     for (final AssetEntity entity in result!) {
//       final File? file = await entity.file;
//       files.add(file!);
//     }
//   }
//   return files;
// }

  ///Handle Document After Picker
// handleDocumentAfterPicker(BuildContext context, Function(List<File>) resultBlock) async {
//   List<File> files = [];
//   FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx'],);
//
//   if(result != null) {
//     // files = result.paths.map((path) => PickedFile(path ?? "")).toList();
//     files = result.paths.map((path) => File(path ?? "")).toList();
//   }
//   resultBlock(files);
// }
}