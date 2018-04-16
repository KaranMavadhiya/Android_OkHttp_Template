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

#### License

~~~~
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
~~~~
