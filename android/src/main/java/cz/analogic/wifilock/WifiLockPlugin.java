package cz.analogic.wifilock;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.app.Activity;
import android.os.Build;
import android.content.Context;
import android.net.wifi.WifiManager;

public class WifiLockPlugin implements MethodCallHandler {

  private static final String CHANNEL = "wifi_lock";
  private WifiManager.WifiLock wifiLock;
  private final Activity activity;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
    channel.setMethodCallHandler(new WifiLockPlugin(registrar.activity()));
  }

  private WifiLockPlugin(Activity activity) {
    this.activity = activity;
  }

  public void onMethodCall(MethodCall call, Result result) {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.CUPCAKE) {
      result.error("UNAVAILABLE", "Obsolete android version", null);
      return;
    }

    if (call.method.equals("acquire")) {
      if(acquire((int) call.argument("type"))) {
        result.success(null);
      } else {
        result.error("UNAVAILABLE", "WifiManager not present", null);
      }
    } else if (call.method.equals("release")) {
      if(release()) {
        result.success(null);
      } else {
        result.error("UNAVAILABLE", "Lock is already released", null);
      }
    } else if (call.method.equals("isHeld")) {
      result.success(isHeld());
    } else {
      result.notImplemented();
    }
  }

  private boolean acquire(int type) throws NullPointerException
  {
    WifiManager wifi = (WifiManager) activity.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
    if(wifi == null) {
      return false;
    }

    wifiLock = wifi.createWifiLock(type, "discovery");
    wifiLock.acquire();

    return true;
  }

  private boolean release() {
    try {
      wifiLock.release();
    } catch(RuntimeException e) {
      return false;
    }

    return true;
  }

  private boolean isHeld() {
    return wifiLock.isHeld();
  }
}
