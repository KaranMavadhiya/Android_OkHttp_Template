package ${packageName}.okhttp;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.support.annotation.NonNull;

import ${packageName}.utils.LogUtil;
import ${packageName}.utils.NetworkUtil;
import ${packageName}.utils.WSConstants;
import ${packageName}.utils.WSResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Credentials;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class OkHttpHelper {

    /*
     * Below mentioned urls are for OkHttp guidance
     * https://guides.codepath.com/android/Using-OkHttp
     * https://github.com/square/okhttp/wiki/Recipes
     */

    /**
     * build.gradle dependencies
     * compile 'com.squareup.okhttp3:okhttp:3.9.1'
     * compile 'com.squareup.okhttp3:logging-interceptor:3.9.1'
     */

    private static final ThreadLocal<String> TAG = new ThreadLocal<String>() {
        @Override
        protected String initialValue() {
            return OkHttpHelper.class.getSimpleName();
        }
    };

    private static boolean OkHttpClientDebug = false;
    private static boolean localDebug = true;

    private static String AUTHORIZED_USER_NAME = "username";
    private static String AUTHORIZED_PASSWORD = "password";

    private static String AUTHORIZATION = "Authorization";
    private static String CREDENTIAL = Credentials.basic(AUTHORIZED_USER_NAME, AUTHORIZED_PASSWORD);


    public OkHttpHelper() {
    }


    /**
     * @param context        Application Context
     * @param url            Base URL
     * @param json           JSONObject
     * @param okHttpCallback Web service callback
     */
    public static void callHttpAsyncPost(Context context, String url, JSONObject json, OkHttpCallback okHttpCallback) {
        if (!NetworkUtil.isNetworkAvailable(context))
            okHttpCallback.onNetworkFailure(WSConstants.error_network, WSConstants.network_error_message);
        else
            callHttpAsyncPost(context, url, json.toString(), okHttpCallback);
    }

    /**
     * @param context        Application Context
     * @param url            Base URL
     * @param json           JSONObject
     * @param okHttpCallback Web service callback
     */
    public static void callHttpAsyncPost(Context context, String url, JSONArray json, OkHttpCallback okHttpCallback) {
        if (!NetworkUtil.isNetworkAvailable(context))
            okHttpCallback.onNetworkFailure(WSConstants.error_network, WSConstants.network_error_message);
        else
            callHttpAsyncPost(context, url, json.toString(), okHttpCallback);
    }

    /**
     * @param context Application Context
     * @param url     Base URL
     * @param json    JSONObject
     * @return WSResponse
     */
    public static WSResponse callHttpSyncPost(Context context, String url, JSONObject json) throws IOException {
        if (!NetworkUtil.isNetworkAvailable(context)) {
            WSResponse wsResponse = new WSResponse();
            wsResponse.setStatusCode(WSConstants.error_network);
            wsResponse.setMessage(WSConstants.network_error_message);
            return wsResponse;
        } else
            return callHttpSyncPost(context, url, json.toString());
    }


    /**
     * @param context Application Context
     * @param url     Base URL
     * @param json    JSONArray
     * @return WSResponse
     */
    public static WSResponse callHttpSyncPost(Context context, String url, JSONArray json) throws IOException {
        if (!NetworkUtil.isNetworkAvailable(context)) {
            WSResponse wsResponse = new WSResponse();
            wsResponse.setStatusCode(WSConstants.error_network);
            wsResponse.setMessage(WSConstants.network_error_message);
            return wsResponse;
        } else
            return callHttpSyncPost(context, url, json.toString());
    }

    /**
     * @param context        Application Context
     * @param url            Base URL
     * @param json           JSONObject
     * @param okHttpCallback Web service callback
     */
    private static void callHttpAsyncPost(Context context, String url, String json, final OkHttpCallback okHttpCallback) {
        OkHttpClient client = OkHttpClientFactory.getOkHttpClientInstance(context, OkHttpClientDebug);
        MediaType JSON = MediaType.parse("application/json; charset=utf-8");
        RequestBody jsonBody = RequestBody.create(JSON, json);

        Request request = new Request.Builder().url(url).post(jsonBody).build();
        if (localDebug) {
            LogUtil.d(TAG.get(), "URL : " + url);
            LogUtil.d(TAG.get(), "Request : " + json);
        }
        // Get a handler that can be used to post to the main thread
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                e.printStackTrace();
                okHttpCallback.onRequestFailure(WSConstants.error_io_exception, WSConstants.server_error_message);
            }

            @Override
            public void onResponse(@NonNull Call call, @NonNull final Response response) throws IOException {
                if (response.code() == WSConstants.success) {
                    String responseString = response.body().string();

                    if (localDebug)
                        LogUtil.d(TAG.get(), "Response : " + responseString);

                    okHttpCallback.onRequestSuccess(response.code(), responseString);
                } else if (response.code() == WSConstants.error_bed_request) {
                    okHttpCallback.onRequestFailure(WSConstants.error_bed_request, WSConstants.bed_request_error_message);
                } else if (response.code() == WSConstants.error_server) {
                    okHttpCallback.onRequestFailure(WSConstants.error_server, WSConstants.server_error_message);
                } else if (response.code() == WSConstants.error_request_timeout || response.code() == WSConstants.error_gateway_timeout) {
                    okHttpCallback.onRequestFailure(WSConstants.error_request_timeout, WSConstants.time_out_error_message);
                } else {
                    okHttpCallback.onRequestFailure(WSConstants.error_server, WSConstants.server_error_message);
                }
            }
        });
    }

    /**
     * @param context Application Context
     * @param url     Base URL
     * @param json    String
     * @return WSResponse
     */
    private static WSResponse callHttpSyncPost(Context context, String url, String json) throws IOException {
        WSResponse wsResponse = new WSResponse();

        long startTime = System.currentTimeMillis();

        OkHttpClient client = OkHttpClientFactory.getOkHttpClientInstance(context, OkHttpClientDebug);
        MediaType JSON = MediaType.parse("application/json; charset=utf-8");
        RequestBody jsonBody = RequestBody.create(JSON, json);

        Request request = new Request.Builder().url(url).post(jsonBody).build();

        Response response = client.newCall(request).execute();
        String responseString = response.body().string();

        long endTime = System.currentTimeMillis();

        if (localDebug) {
            LogUtil.d(TAG.get(), "URL : " + url);
            LogUtil.d(TAG.get(), "Request : " + json);
            LogUtil.d(TAG.get(), "Response : " + responseString);
            LogUtil.d(TAG.get(), "Response Time  : " + (endTime - startTime) + " ms");
        }

        if (response.code() == WSConstants.success) {
            wsResponse.setStatusCode(WSConstants.success);
            wsResponse.setResponse(responseString);
            return wsResponse;
        } else if (response.code() == WSConstants.error_bed_request) {
            wsResponse.setStatusCode(WSConstants.error_bed_request);
            wsResponse.setMessage(WSConstants.bed_request_error_message);
            return wsResponse;
        } else if (response.code() == WSConstants.error_server) {
            wsResponse.setStatusCode(WSConstants.error_server);
            wsResponse.setMessage(WSConstants.server_error_message);
            return wsResponse;
        } else if (response.code() == WSConstants.error_request_timeout || response.code() == WSConstants.error_gateway_timeout) {
            wsResponse.setStatusCode(WSConstants.error_request_timeout);
            wsResponse.setMessage(WSConstants.time_out_error_message);
            return wsResponse;
        } else {
            wsResponse.setStatusCode(WSConstants.error_server);
            wsResponse.setMessage(WSConstants.server_error_message);
            return wsResponse;
        }
    }

    /**
     * @param context        Application Context
     * @param url            Base URL
     * @param requestBody    RequestBody
     * @param okHttpCallback Web service callback
     */
    public static void callHttpAsyncPost(Context context, String url, RequestBody requestBody, final OkHttpCallback okHttpCallback) {
        if (!NetworkUtil.isNetworkAvailable(context)) {
            okHttpCallback.onNetworkFailure(WSConstants.error_network, WSConstants.network_error_message);
            return;
        }

        OkHttpClient client = OkHttpClientFactory.getOkHttpClientInstance(context, OkHttpClientDebug);

        /* You can add params into RequestBody as shown in below commented example code */
        // RequestBody formBody = new FormBody.Builder().add("key", "value").build();

        Request request = new Request.Builder().url(url).post(requestBody).build();

        if (localDebug) {
            LogUtil.d(TAG.get(), "URL : " + url);
            LogUtil.d(TAG.get(), "Request : " + requestBody.toString());
        }

        // Get a handler that can be used to post to the main thread
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                e.printStackTrace();
                okHttpCallback.onRequestFailure(WSConstants.error_io_exception, WSConstants.server_error_message);
            }

            @Override
            public void onResponse(@NonNull Call call, @NonNull final Response response) throws IOException {
                if (response.code() == WSConstants.success) {
                    String responseString = response.body().string();

                    if (localDebug)
                        LogUtil.d(TAG.get(), "Response : " + responseString);

                    okHttpCallback.onRequestSuccess(response.code(), responseString);
                } else if (response.code() == WSConstants.error_bed_request) {
                    okHttpCallback.onRequestFailure(WSConstants.error_bed_request, WSConstants.bed_request_error_message);
                } else if (response.code() == WSConstants.error_server) {
                    okHttpCallback.onRequestFailure(WSConstants.error_server, WSConstants.server_error_message);
                } else if (response.code() == WSConstants.error_request_timeout || response.code() == WSConstants.error_gateway_timeout) {
                    okHttpCallback.onRequestFailure(WSConstants.error_request_timeout, WSConstants.time_out_error_message);
                } else {
                    okHttpCallback.onRequestFailure(WSConstants.error_server, WSConstants.server_error_message);
                }
            }
        });
    }

    /**
     * @param context        Application Context
     * @param url            Base URL
     * @param requestBody    RequestBody
     * @param okHttpCallback Web service callback
     */
    public static void callHttpAsyncMultiPart(final Context context, final String url, final RequestBody requestBody, final OkHttpCallback okHttpCallback) {
        if (!NetworkUtil.isNetworkAvailable(context)) {
            okHttpCallback.onNetworkFailure(WSConstants.error_network, WSConstants.network_error_message);
            return;
        }

        OkHttpClient client = OkHttpClientFactory.getOkHttpClientInstance(context, OkHttpClientDebug);

        /* You can add multipart params into RequestBody as shown in below commented example code */
        // MediaType MEDIA_TYPE = MediaType.parse("image/*");
        // MultipartBody.Builder requestBody = new MultipartBody.Builder().setType(MultipartBody.FORM);
        // requestBody.addFormDataPart("KEY", "VALUE");
        // requestBody.addFormDataPart("IMAGE_KEY", "IMAGE_NAME", RequestBody.create(MEDIA_TYPE,  new File("FILE_PATH")));


        Request request = new Request.Builder().url(url).post(requestBody).build();

        if (localDebug) {
            LogUtil.d(TAG.get(), "URL : " + url);
            LogUtil.d(TAG.get(), "Request : " + requestBody.toString());
        }

        // Get a handler that can be used to post to the main thread
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                e.printStackTrace();
                okHttpCallback.onRequestFailure(WSConstants.error_io_exception, WSConstants.server_error_message);
            }

            @Override
            public void onResponse(@NonNull Call call, @NonNull final Response response) throws IOException {
                if (response.code() == WSConstants.success) {
                    String responseString = response.body().string();

                    if (localDebug)
                        LogUtil.d(TAG.get(), "Response : " + responseString);

                    okHttpCallback.onRequestSuccess(response.code(), responseString);
                } else if (response.code() == WSConstants.error_bed_request) {
                    okHttpCallback.onRequestFailure(WSConstants.error_bed_request, WSConstants.bed_request_error_message);
                } else if (response.code() == WSConstants.error_server) {
                    okHttpCallback.onRequestFailure(WSConstants.error_server, WSConstants.server_error_message);
                } else if (response.code() == WSConstants.error_request_timeout || response.code() == WSConstants.error_gateway_timeout) {
                    okHttpCallback.onRequestFailure(WSConstants.error_request_timeout, WSConstants.time_out_error_message);
                } else {
                    okHttpCallback.onRequestFailure(WSConstants.error_server, WSConstants.server_error_message);
                }
            }
        });
    }

    /**
     * @param context        Application Context
     * @param url            Base URL
     * @param okHttpCallback Web service callback
     */
    public static void callHttpAsyncGet(final Context context, final String url, final OkHttpCallback okHttpCallback) {
        if (!NetworkUtil.isNetworkAvailable(context)) {
            okHttpCallback.onNetworkFailure(WSConstants.error_network, WSConstants.network_error_message);
            return;
        }

        OkHttpClient client = OkHttpClientFactory.getOkHttpClientInstance(context, OkHttpClientDebug);
        Request.Builder builder = new Request.Builder();
        builder.url(url);

        /* Add authentication header if required */
        // builder.header(AUTHORIZATION, CREDENTIAL);
        if (localDebug)
            LogUtil.d(TAG.get(), "URL : " + url);

        // Get a handler that can be used to post to the main thread
        client.newCall(builder.build()).enqueue(new Callback() {
            @Override
            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                e.printStackTrace();
                okHttpCallback.onRequestFailure(WSConstants.error_io_exception, WSConstants.server_error_message);
            }

            @Override
            public void onResponse(@NonNull Call call, @NonNull final Response response) throws IOException {
                if (response.code() == WSConstants.success) {
                    String responseString = response.body().string();

                    if (localDebug)
                        LogUtil.d(TAG.get(), "Response : " + responseString);

                    okHttpCallback.onRequestSuccess(response.code(), responseString);
                } else if (response.code() == WSConstants.error_bed_request) {
                    okHttpCallback.onRequestFailure(WSConstants.error_bed_request, WSConstants.bed_request_error_message);
                } else if (response.code() == WSConstants.error_server) {
                    okHttpCallback.onRequestFailure(WSConstants.error_server, WSConstants.server_error_message);
                } else if (response.code() == WSConstants.error_request_timeout || response.code() == WSConstants.error_gateway_timeout) {
                    okHttpCallback.onRequestFailure(WSConstants.error_request_timeout, WSConstants.time_out_error_message);
                } else {
                    okHttpCallback.onRequestFailure(WSConstants.error_server, WSConstants.server_error_message);
                }
            }
        });
    }

    /**
     * @param context     Application Context
     * @param url         Base URL
     * @param requestBody RequestBody
     * @return WSResponse
     */
    public static WSResponse callHttpSyncPost(Context context, String url, RequestBody requestBody) throws IOException {
        WSResponse wsResponse = new WSResponse();

        if (!NetworkUtil.isNetworkAvailable(context)) {
            wsResponse.setStatusCode(WSConstants.error_network);
            wsResponse.setMessage(WSConstants.network_error_message);
            return wsResponse;
        }

        long startTime = System.currentTimeMillis();

        OkHttpClient client = OkHttpClientFactory.getOkHttpClientInstance(context, OkHttpClientDebug);

        /* You can add params into RequestBody as shown in below commented example code */
        // RequestBody formBody = new FormBody.Builder().add("key", "value").build();

        Request request = new Request.Builder().url(url).post(requestBody).build();

        Response response = client.newCall(request).execute();
        String responseString = response.body().string();
        long endTime = System.currentTimeMillis();

        if (localDebug) {
            LogUtil.d(TAG.get(), "URL : " + url);
            LogUtil.d(TAG.get(), "Request : " + requestBody.toString());
            LogUtil.d(TAG.get(), "Response : " + responseString);
            LogUtil.d(TAG.get(), "Response Time  : " + (endTime - startTime) + " ms");
        }

        if (response.code() == WSConstants.success) {
            wsResponse.setStatusCode(WSConstants.success);
            wsResponse.setResponse(responseString);
            return wsResponse;
        } else if (response.code() == WSConstants.error_bed_request) {
            wsResponse.setStatusCode(WSConstants.error_bed_request);
            wsResponse.setMessage(WSConstants.bed_request_error_message);
            return wsResponse;
        } else if (response.code() == WSConstants.error_server) {
            wsResponse.setStatusCode(WSConstants.error_server);
            wsResponse.setMessage(WSConstants.server_error_message);
            return wsResponse;
        } else if (response.code() == WSConstants.error_request_timeout || response.code() == WSConstants.error_gateway_timeout) {
            wsResponse.setStatusCode(WSConstants.error_request_timeout);
            wsResponse.setMessage(WSConstants.time_out_error_message);
            return wsResponse;
        } else {
            wsResponse.setStatusCode(WSConstants.error_server);
            wsResponse.setMessage(WSConstants.server_error_message);
            return wsResponse;
        }
    }

    /**
     * @param context     Application Context
     * @param url         Base URL
     * @param requestBody RequestBody
     * @return WSResponse
     */
    public static WSResponse callHttpSyncMultiPart(final Context context, final String url, final RequestBody requestBody) throws IOException {
        WSResponse wsResponse = new WSResponse();

        if (!NetworkUtil.isNetworkAvailable(context)) {
            wsResponse.setStatusCode(WSConstants.error_network);
            wsResponse.setMessage(WSConstants.network_error_message);
            return wsResponse;
        }

        long startTime = System.currentTimeMillis();

        OkHttpClient client = OkHttpClientFactory.getOkHttpClientInstance(context, OkHttpClientDebug);

        /* You can add multipart params into RequestBody as shown in below commented example code */
        // MediaType MEDIA_TYPE = MediaType.parse("image/*");
        // MultipartBody.Builder requestBody = new MultipartBody.Builder().setType(MultipartBody.FORM);
        // requestBody.addFormDataPart("KEY", "VALUE");
        // requestBody.addFormDataPart("IMAGE_KEY", "IMAGE_NAME", RequestBody.create(MEDIA_TYPE,  new File("FILE_PATH")));


        Request request = new Request.Builder().url(url).post(requestBody).build();

        Response response = client.newCall(request).execute();
        String responseString = response.body().string();
        long endTime = System.currentTimeMillis();

        if (localDebug) {
            LogUtil.d(TAG.get(), "URL : " + url);
            LogUtil.d(TAG.get(), "Request : " + requestBody.toString());
            LogUtil.d(TAG.get(), "Response : " + responseString);
            LogUtil.d(TAG.get(), "Response Time  : " + (endTime - startTime) + " ms");
        }

        if (response.code() == WSConstants.success) {
            wsResponse.setStatusCode(WSConstants.success);
            wsResponse.setResponse(responseString);
            return wsResponse;
        } else if (response.code() == WSConstants.error_bed_request) {
            wsResponse.setStatusCode(WSConstants.error_bed_request);
            wsResponse.setMessage(WSConstants.bed_request_error_message);
            return wsResponse;
        } else if (response.code() == WSConstants.error_server) {
            wsResponse.setStatusCode(WSConstants.error_server);
            wsResponse.setMessage(WSConstants.server_error_message);
            return wsResponse;
        } else if (response.code() == WSConstants.error_request_timeout || response.code() == WSConstants.error_gateway_timeout) {
            wsResponse.setStatusCode(WSConstants.error_request_timeout);
            wsResponse.setMessage(WSConstants.time_out_error_message);
            return wsResponse;
        } else {
            wsResponse.setStatusCode(WSConstants.error_server);
            wsResponse.setMessage(WSConstants.server_error_message);
            return wsResponse;
        }
    }

    /**
     * @param context Application Context
     * @param url     Base URL
     * @return WSResponse
     */
    public static WSResponse callHttpSyncGet(final Context context, final String url) throws IOException {
        WSResponse wsResponse = new WSResponse();

        if (!NetworkUtil.isNetworkAvailable(context)) {
            wsResponse.setStatusCode(WSConstants.error_network);
            wsResponse.setMessage(WSConstants.network_error_message);
            return wsResponse;
        }

        long startTime = System.currentTimeMillis();

        OkHttpClient client = OkHttpClientFactory.getOkHttpClientInstance(context, OkHttpClientDebug);
        Request.Builder builder = new Request.Builder();
        builder.url(url);

        /* Add authentication header if required */
        // builder.header(AUTHORIZATION, CREDENTIAL);

        Response response = client.newCall(builder.build()).execute();
        String responseString = response.body().string();
        long endTime = System.currentTimeMillis();

        if (localDebug) {
            LogUtil.d(TAG.get(), "URL : " + url);
            LogUtil.d(TAG.get(), "Response : " + responseString);
            LogUtil.d(TAG.get(), "Response Time  : " + (endTime - startTime) + " ms");
        }

        if (response.code() == WSConstants.success) {
            wsResponse.setStatusCode(WSConstants.success);
            wsResponse.setResponse(responseString);
            return wsResponse;
        } else if (response.code() == WSConstants.error_bed_request) {
            wsResponse.setStatusCode(WSConstants.error_bed_request);
            wsResponse.setMessage(WSConstants.bed_request_error_message);
            return wsResponse;
        } else if (response.code() == WSConstants.error_server) {
            wsResponse.setStatusCode(WSConstants.error_server);
            wsResponse.setMessage(WSConstants.server_error_message);
            return wsResponse;
        } else if (response.code() == WSConstants.error_request_timeout || response.code() == WSConstants.error_gateway_timeout) {
            wsResponse.setStatusCode(WSConstants.error_request_timeout);
            wsResponse.setMessage(WSConstants.time_out_error_message);
            return wsResponse;
        } else {
            wsResponse.setStatusCode(WSConstants.error_server);
            wsResponse.setMessage(WSConstants.server_error_message);
            return wsResponse;
        }
    }
}