#define WDBSetWebSecurityEnabled_h

#import "WDBFakeWebKitPointer.h"

// Allows disabling Same-Origin Policy on iOS WKWebView.
// Tested on iOS 12.4.
// Uses private API; obviously can't be used on app store.

@import WebKit;
@import ObjectiveC;

void WKPreferencesSetWebSecurityEnabled(id, bool);

void WDBSetWebSecurityEnabled(WKPreferences* prefs, bool enabled) {
    Ivar ivar = class_getInstanceVariable([WKPreferences class], "_preferences");
    void* realPreferences = (void*)(((uintptr_t)prefs) + ivar_getOffset(ivar));
    WDBFakeWebKitPointer* fake = [WDBFakeWebKitPointer new];
    fake._apiObject = realPreferences;
    WKPreferencesSetWebSecurityEnabled(fake, enabled);
}
