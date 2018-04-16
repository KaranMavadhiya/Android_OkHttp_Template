# Android OkHttp Template
#### This is a simple okhttp-template to save your time to impliment OkHttp library.

When you use this template it will automatically create some packages like okhttp and utils which contains following files.

   #### OkHttp
   * OkHttpCallback.java        (callback interface for Asynchronious call)   
   * OkHttpClientFactory.java   (OkHttpClient Builder)
   * OkHttpHelper.java          (Helper class for Synchronious and Asynchronious call)
   
   #### utils
   * LogUtil.java      
   * NetworkUtil.java  (Check internet connection)
   * WSConstants.java  (Constants class for response code and message)
   * WSResponse.java   (Response class for Synchronious call)
   
   #### How to use it:
* Step 1: Clone/Download this repository.
* Step 2: Copy OkHttp folder and Navigate to the location of the templates folder and Paste it into plugins/.../templates/other
~~~~
Windows: {ANDROID_STUDIO_LOCATION}/plugins/android/lib/templates/other/
~~~~

~~~~
Mac: /Applications/Android Studio.app/Contents/plugins/android/lib/templates/other/
~~~~
* Step 3: right click any package of your new/existing project and select New/Other/OkHttp
