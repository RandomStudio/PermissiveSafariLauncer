import UIKit
import WebKit

// Features:
// - Treats HTTP as secure (enables camera access etc)
// - Ignores CORS
// - Ensures windows is inspectable in Safari
// - Automatically accept camera/media permissions requests, without dialog
// - Allow video/audio to autoplay without interaction

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var uiView: UIView!
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupWebView()
        
        let launchURL = SettingsBundleHelper.getLaunchURL();

        if (launchURL != nil) {
            navigateToPage(url: launchURL!)
        }
    }
    
    func setupWebView() {
        let preferences = WKPreferences()
        
        // Disables CORS, see related WDBSetWebSecurityEnabled.h file for implementation
        WDBSetWebSecurityEnabled(preferences, false);

        // Treat HTTP as HTTPS / secure
        let pool = WKProcessPool()
        let selector = NSSelectorFromString("_registerURLSchemeAsSecure:")
        pool.perform(selector, with: NSString(string: "http"))

        // Create webview with config
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        // Remove autoplay restrictions on video/audio
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        webView = WKWebView(frame: uiView.bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self

        // Ensure window is inspectable in Safari
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        
        uiView.addSubview(self.webView!)
    }
    
    func navigateToPage(url: String) {
        guard let url = URL(string: url) else {
            print("Failed to create URL")
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }

    // Automatically accept camera/microphone permission requests
    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }
}

