package ${packageName}.okhttp;

public interface OkHttpCallback {
    void onRequestSuccess(int statusCode, String response);
    void onRequestFailure(int statusCode, String message);
    void onNetworkFailure(int statusCode, String message);
}
