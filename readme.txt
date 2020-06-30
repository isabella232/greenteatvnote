ой чет пиздец... с названиями... substring работет уебищно

20200406
new enviroment used gradle overwrite AndroidManifest.mxl of project package name to default from
/home/user/dev/haxelib/lime/7,7,0/templates/android/template/app/build.gradle
as result play store drop out apk after upload complete, because wrong name.
Hardcoded choosing applicationId from "com.example.myapp" to

defaultConfig {
		applicationId "com.gtnote.myapp"
		minSdkVersion Integer.parseInt(project.ANDROID_BUILD_MIN_SDK_VERSION)
		targetSdkVersion Integer.parseInt(project.ANDROID_BUILD_TARGET_SDK_VERSION)
		versionCode Integer.parseInt(project.VERSION_CODE)
		versionName project.VERSION_NAME
		::if (languages != null)::resConfigs ::foreach languages::"::__current__::", ::end::""::end::
	}
	
fix this