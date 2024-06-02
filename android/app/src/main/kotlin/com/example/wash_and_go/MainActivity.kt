package com.example.wash_and_go
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory
import android.app.Application

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    
    MapKitFactory.setApiKey("f0680c0c-dbc1-4c54-845b-c12be98c69d1") // Your generated API key
    super.configureFlutterEngine(flutterEngine)
  }
}