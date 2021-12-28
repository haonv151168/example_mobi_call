## Flutter MobiCall Example Project.
  - [Usage Example](#example)
  - [How to implement Flutter MobiCall Plugin ?](#implement)
    - [IOS](#ios)
      - [Podfile](#podfile)
      - [Info.plist](#infoplist)
    - [Android](#android)
      - [Gradle](#gradle)
      - [AndroidManifest.xml](#androidmanifestxml)
      - [Minimum SDK Version 23](#minimum-sdk-version-23)
      - [Proguard](#proguard)
  - [Code Example](#code_example)
  - [Join a Meeting Programmatically](#join-a-meeting-programmatically)
  - [Closing a Meeting Programmatically](#closing-a-meeting-programmatically)

<a name="example"></a>
## Usage Example
* Note: Example compilable with XCode 13.1 & Flutter 2.8.0 & Dart 2.15.0.

### Clone project
`git clone https://github.com/haonv151168/example_mobi_call.git`

### Checkout in tong_dai branch
`git checkout -b tong_dai`

### Pull code in tong_dai branch 
`git pull origin tong_dai`

### Change directory 
`cd example_mobi_call`

### Open project in IDE( vscode )
`code .` and Run project


<a name="implement"></a>
## How to implement Flutter MobiCall Plugin ?

<a name="ios"></a>
### IOS
* Note: Example compilable with XCode 12.2 & Flutter 1.22.4.

#### Podfile
Ensure in your Podfile you have an entry like below declaring platform of 11.0 or above and disable BITCODE.
```
platform :ios, '11.0'

...

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

#### Info.plist
Add NSCameraUsageDescription and NSMicrophoneUsageDescription to your
Info.plist.

text
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) MobiCall needs access to your camera for meetings.</string>
<key>NSMicrophoneUsageDescription</key>
<string>$(PRODUCT_NAME) MobiCall needs access to your microphone for meetings.</string>


<a name="android"></a>
### Android

#### Gradle
Set dependencies of build tools gradle to minimum 3.6.3:
gradle
dependencies {
    classpath 'com.android.tools.build:gradle:3.6.3' <!-- Upgrade this -->
    classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
}


Set distribution gradle wrapper to minimum 5.6.4.
gradle
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-5.6.4-all.zip <!-- Upgrade this -->


#### AndroidManifest.xml
Jitsi Meet's SDK AndroidManifest.xml will conflict with your project, namely 
the application:label field. To counter that, go into 
`android/app/src/main/AndroidManifest.xml` and add the tools library
and `tools:replace="android:label"` to the application tag.

xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="yourpackage.com"
    xmlns:tools="http://schemas.android.com/tools"> <!-- Add this -->
    <application 
        tools:replace="android:label"  
        android:name="your.application.name"
        android:label="My Application"
        android:icon="@mipmap/ic_launcher">
        ...
    </application>
...
</manifest>`

#### Minimum SDK Version 23
Update your minimum sdk version to 23 in android/app/build.gradle
groovy
defaultConfig {
    minSdkVersion 23 
    targetSdkVersion 28
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
}


#### Proguard

Jitsi's SDK enables proguard, but without a proguard-rules.pro file, your release 
apk build will be missing the Flutter Wrapper as well as react-native code. 
In your Flutter project's android/app/build.gradle file, add proguard support

```groovy
buildTypes {
    release {
        // TODO: Add your own signing config for the release build.
        // Signing with the debug keys for now, so `flutter run --release` works.
        signingConfig signingConfigs.debug
        
        // Add below 3 lines for proguard
        minifyEnabled true
        useProguard true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

Then add a file in the same directory called proguard-rules.pro. See the example 
app's [proguard-rules.pro](example/android/app/proguard-rules.pro) file to know what to paste in.

Note  
If you do not create the proguard-rules.pro file, then your app will 
crash when you try to join a meeting or the meeting screen tries to open
but closes immediately. You will see one of the below errors in logcat.


## App crashes ##
java.lang.RuntimeException: Parcel android.os.Parcel@8530c57: Unmarshalling unknown type code 7536745 at offset 104
    at android.os.Parcel.readValue(Parcel.java:2747)
    at android.os.Parcel.readSparseArrayInternal(Parcel.java:3118)
    at android.os.Parcel.readSparseArray(Parcel.java:2351)
    .....



## Meeting won't open and you go to previous screen ##
W/unknown:ViewManagerPropertyUpdater: Could not find generated setter for class com.BV.LinearGradient.LinearGradientManager
W/unknown:ViewManagerPropertyUpdater: Could not find generated setter for class com.facebook.react.uimanager.g
W/unknown:ViewManagerPropertyUpdater: Could not find generated setter for class com.facebook.react.views.art.ARTGroupViewManager
W/unknown:ViewManagerPropertyUpdater: Could not find generated setter for class com.facebook.react.views.art.a
.....`

<a name="code_example"></a>

## Implements MobifoneHelperListener and CallListener

```dart
class _DetailScreenState extends State<DetailScreen> implements MobifoneHelperListener, CallListener { 
    ....
}
```

## Config to socket and setting jwt token.

```dart
@override
void initState() {
    super.initState();
    Config.socketUrl = "http://103.199.79.64:3000";
    Config.jwt_token = "eyJhbGciOiJIUzI1.eyJzdWIiOiIMDIyfQ.SV_adQssw5c";
    MobifoneClient().mobifoneHelperListener = this;
    MobifoneClient().callListener = this;
    MobifoneClient().connectServer(context);
}

```

## Client event 

```dart
  @override
  onConnectionConnect() {
    print("event connected");
  }

  @override
  onConnectionError() {
    print("event connect failure");
  }

  @override
  onError(String? message) {
    if (message != null) {
      _showToast(context, message);
      print("message onError: " + message.toString());
    }
  }

  @override
  onSignalingStateChange(String state, SignalResponModel? model) {

    switch (state) {
      case Config.EVENT_CALLING:
        // func handle EVENT_CALLING
        break;
      case Config.EVENT_RINGING:
        // func handle EVENT_RINGING
        break;
      case Config.EVENT_MISS:
        // func handle EVENT_MISS
        break;
      case Config.EVENT_REJECT:
        // func handle EVENT_REJECT
        break;
      case Config.EVENT_CANCEL:
        // func handle EVENT_CANCEL
        break;
      case Config.EVENT_ACCEPT:
        // func handle EVENT_ACCEPT
        break;
      case Config.EVENT_END:
        // func handle EVENT_END
        break;
      case Config.EVENT_TERMINATED:
        // func handle EVENT_TERMINATED, 
        MobifoneClient().endCall(); // required
        break;
      default:
        break;
    }
    print("state: " + state);
  }
```

<a name="join-a-meeting-programmatically"></a>

## Code make call to hotline

```dart
MobifoneClient().makeCall("19001009", "", null, "c2h");
```

```dart
MobifoneClient().cancelCall();
```

```dart
MobifoneClient().rejectCall();
```

```dart
MobifoneClient().endCall();
```

```dart
MobifoneClient().acceptCall();
```

```dart
MobifoneClient().joinMeeting();
```

```dart
MobifoneClient().closeMeeting();
```
