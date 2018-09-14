# wifi_lock

Flutter plugin adding ability to access [WifiLock](https://developer.android.com/reference/android/net/wifi/WifiManager.WifiLock)

## Example code

pubspec.yaml:
```yaml
...
dependencies:
  wifi_lock: any
```


example dart code:
```dart
import 'package:wifi_lock/wifi_lock.dart';


void main() {
  final WifiLock = new WifiLock(WifiLock.WIFI_MODE_FULL_HIGH_PERF);
  wifiLock.acquire();
  
  
  // ...
  // we should release at the end of work with wifi
  wifiLock.release();
}

```