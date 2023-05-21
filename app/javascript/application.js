// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "bootstrap"
class Bridge {

    // Sends a message to the native app, if active.
    static postMessage(name, data = {}) {
      // iOS
      window.webkit?.messageHandlers?.nativeApp?.postMessage({name, ...data})
    }
  }
  
  // Expose this on the window object so TurboNative can interact with it
  window.Bridge = Bridge
  export default Bridge
  