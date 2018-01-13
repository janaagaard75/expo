// Copyright 2015-present 650 Industries. All rights reserved.

package versioned.host.exp.exponent.modules.api;

import android.graphics.Typeface;
import android.net.Uri;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.views.text.ReactFontManager;

import java.io.File;

public class FontLoaderModule extends ReactContextBaseJavaModule {
  private static final String ASSET_SCHEME = "asset://";

  public FontLoaderModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "ExponentFontLoader";
  }

  @ReactMethod
  public void loadAsync(final String fontFamilyName, final String localUri, final Promise promise) {
    try {
      // TODO(nikki): make sure path is in experience's scope
      Typeface typeface;
      if (localUri.startsWith(ASSET_SCHEME)) {
        typeface = Typeface.createFromAsset(
            getReactApplicationContext().getAssets(),
            // Also remove the leading slash.
            localUri.substring(ASSET_SCHEME.length() + 1));
      } else {
        typeface = Typeface.createFromFile(new File(Uri.parse(localUri).getPath()));
      }
      ReactFontManager.getInstance().setTypeface("ExponentFont-" + fontFamilyName, Typeface.NORMAL, typeface);
      promise.resolve(Arguments.createMap());
    } catch (Exception e) {
      promise.reject(e);
    }
  }
}
