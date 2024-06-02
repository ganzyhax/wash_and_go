import android.app.Application;

import com.yandex.mapkit.MapKitFactory;

public class MainActivity extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        MapKitFactory.setLocale("ru_RU"); // Your preferred language. Not required, defaults to system language
        MapKitFactory.setApiKey("f0680c0c-dbc1-4c54-845b-c12be98c69d1"); // Your generated API key
    }
}