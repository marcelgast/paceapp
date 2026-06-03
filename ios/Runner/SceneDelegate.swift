import Flutter
import UIKit

/// Captures the widget deep link (pace://boxenstopp) and stashes it in the
/// shared App Group. The new Flutter scene delegate only forwards URL contexts
/// to plugins adopting the scene life-cycle protocol — home_widget doesn't — so
/// we grab it here and let the Flutter side read the flag on launch/resume.
class SceneDelegate: FlutterSceneDelegate {
  private let appGroup = "group.de.mgstudios.pace"

  override func scene(_ scene: UIScene,
                      willConnectTo session: UISceneSession,
                      options connectionOptions: UIScene.ConnectionOptions) {
    capture(connectionOptions.urlContexts)
    super.scene(scene, willConnectTo: session, options: connectionOptions)
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    capture(URLContexts)
    super.scene(scene, openURLContexts: URLContexts)
  }

  private func capture(_ contexts: Set<UIOpenURLContext>) {
    for ctx in contexts where ctx.url.host == "boxenstopp" {
      UserDefaults(suiteName: appGroup)?.set("boxenstopp", forKey: "pending_action")
    }
  }
}
