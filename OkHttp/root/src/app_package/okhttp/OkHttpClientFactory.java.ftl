package ${packageName}.okhttp;

import android.content.Context;

import java.io.File;
import java.util.concurrent.TimeUnit;

import okhttp3.Cache;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;


public class OkHttpClientFactory {


    private static OkHttpClient.Builder okHttpInstance;

    private final static long CONNECTION_TIME_OUT = 30;
    private final static long READ_TIME_OUT = 60;

    private static final int DISK_CACHE_SIZE = 10 * 1024 * 1024; // 10MB

    private OkHttpClientFactory(){}

    public static OkHttpClient getOkHttpClientInstance(Context context, boolean isDebug){
        if(okHttpInstance == null){
            // Install an HTTP cache in the context cache directory.
            File cacheDir = new File(context.getCacheDir(), "http");
            Cache cache = new Cache(cacheDir, DISK_CACHE_SIZE);

            okHttpInstance = new okhttp3.OkHttpClient().newBuilder().cache(cache);
            okHttpInstance.connectTimeout(CONNECTION_TIME_OUT, TimeUnit.SECONDS);
            okHttpInstance.readTimeout(READ_TIME_OUT, TimeUnit.SECONDS);

            if (isDebug) {
                HttpLoggingInterceptor loggingInterceptor = new HttpLoggingInterceptor();
                loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
                okHttpInstance.addInterceptor(loggingInterceptor);
            }
        }
        return okHttpInstance.build();
    }

    public static OkHttpClient getOkHttpClientInstance(Context context) {
        return getOkHttpClientInstance(context, false);
    }
}
