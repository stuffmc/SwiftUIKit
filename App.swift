import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UISceneDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication .LaunchOptionsKey: Any]?) -> Bool { true }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
}

class ViewController: UIViewController {
    private let viewModel = ViewModel()
    private let label = UILabel()
    private let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        label.textColor = .white
        button.setTitle("Inc from UIKit", for: .normal)
        button.addTarget(viewModel, action: #selector(ViewModel.increment), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [label, button,
           UIHostingController(rootView: ContentView(viewModel: viewModel)).view
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        observe()
    }
    
    func observe() {
        withObservationTracking {
            label.text = "UIKit: \(viewModel.count)"
        } onChange: { Task { @MainActor in self.observe() } }
    }
}

@Observable class ViewModel {
    private(set) var count = 0
    @objc func increment() { count += 1 }
}

struct ContentView: View {
    var viewModel: ViewModel

    var body: some View {
        VStack {
            Button("Inc from SwiftUI") { viewModel.increment() }
            Text("SwiftUI: \(viewModel.count)")
        }
        .background(Color.yellow)
    }
}

struct RepresentedView: UIViewRepresentable {
    let vc = ViewController()
    func makeUIView(context: Context) -> some UIView { vc.view }
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

#Preview {
    RepresentedView()
        .background(Color.black)
}
