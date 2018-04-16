<?xml version="1.0"?>
<recipe>

	<merge from="root/AndroidManifest.xml.ftl"
             to="${escapeXmlAttribute(manifestOut)}/AndroidManifest.xml" />

     	 <dependency mavenUrl="com.squareup.okhttp3:okhttp:3.9.1" />
    	 <dependency mavenUrl="com.squareup.okhttp3:logging-interceptor:3.9.1" />
    	 <dependency mavenUrl="com.android.support:support-annotations:27.0.2" />

	<instantiate 
	     from="root/src/app_package/utils/LogUtil.java.ftl"
             to="${escapeXmlAttribute(srcOut)}/utils/LogUtil.java" />

	<instantiate 
	     from="root/src/app_package/utils/NetworkUtil.java.ftl"
             to="${escapeXmlAttribute(srcOut)}/utils/NetworkUtil.java" />

	<instantiate 
	     from="root/src/app_package/utils/WSConstants.java.ftl"
             to="${escapeXmlAttribute(srcOut)}/utils/WSConstants.java" />

	<instantiate 
	     from="root/src/app_package/utils/WSResponse.java.ftl"
             to="${escapeXmlAttribute(srcOut)}/utils/WSResponse.java" />


	<instantiate 
	     from="root/src/app_package/okhttp/OkHttpCallback.java.ftl"
             to="${escapeXmlAttribute(srcOut)}/okhttp/OkHttpCallback.java" />

	<instantiate 
	     from="root/src/app_package/okhttp/OkHttpClientFactory.java.ftl"
             to="${escapeXmlAttribute(srcOut)}/okhttp/OkHttpClientFactory.java" />

	<instantiate 
	     from="root/src/app_package/okhttp/OkHttpHelper.java.ftl"
             to="${escapeXmlAttribute(srcOut)}/okhttp/OkHttpHelper.java" />

</recipe>
