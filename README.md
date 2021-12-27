#  Flutter MobiCall Example Project.

## Usage

### Clone project
`git clone https://github.com/haonv151168/example_mobi_call.git`

### Change directory 
`cd example_mobi_call`

### Open project in IDE( vscode )
`code .`

### In `TERMINAL` VSCODE

#### Config IOS 
`cd ios`
`open Podfile` and change :

```diff 
+ # platform :ios, '9.0'
``` 

TO

```diff 
+ platform :ios, '11.0'
```

```diff
+post_install do |installer|
+  installer.pods_project.targets.each do |target|
+    flutter_additional_ios_build_settings(target)
+  end
+end
```  

TO

 ```diff
+post_install do |installer|
+  installer.pods_project.targets.each do |target|
+    target.build_configurations.each do |config|
+      config.build_settings['ENABLE_BITCODE'] = 'NO'
+    end
+    flutter_additional_ios_build_settings(target)
+  end
+end
```

Add to `Info.plist`
```diff 
+<key>NSCameraUsageDescription</key>
+<string>$(PRODUCT_NAME) MobiCall needs access to your camera for meetings.</string>
+<key>NSMicrophoneUsageDescription</key>
+<string>$(PRODUCT_NAME) MobiCall needs access to your microphone for meetings.</string>
``` 


### RUN.