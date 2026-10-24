// iOS's launcher: a UIKit screen shown before the game's window, from which the player extracts the game data from
// their disc image, changes the APP SETTINGS and starts the game. The main thread turns the run loop here until Play
// is tapped, as the game does from its own loop later.

import ChronicleBridge
import CxxStdlib
import UIKit
import UniformTypeIdentifiers

private let accent = UIColor(red: 0.93, green: 0.74, blue: 0.36, alpha: 1)

@MainActor private var deviceName: String { UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone" }

@MainActor private func makeButton(_ title: String, _ symbol: String, primary: Bool) -> UIButton {
    var configuration: UIButton.Configuration = primary ? .filled() : .gray()
    configuration.title = title
    configuration.image = UIImage(systemName: symbol)
    configuration.imagePadding = 8
    configuration.cornerStyle = .large
    configuration.buttonSize = .large
    if primary {
        configuration.baseBackgroundColor = accent
        configuration.baseForegroundColor = .black
    } else {
        configuration.baseForegroundColor = .white
    }
    let button = UIButton(configuration: configuration, primaryAction: nil)
    button.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
    return button
}

@MainActor private func setTitle(_ button: UIButton, _ title: String, _ symbol: String) {
    var configuration = button.configuration
    configuration?.title = title
    configuration?.image = UIImage(systemName: symbol)
    button.configuration = configuration
}

@MainActor private func alert(_ title: String, _ message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    return alert
}

// The APP SETTINGS rows of the game's Options page, each with the arrows that step it as Left and Right do in the
// game. Binding rows wait for a key in the game, so they stay there.
private final class SettingsController: UITableViewController {
    private var sections: [(page: Int32, rows: [Int32])] = []

    init() {
        super.init(style: .insetGrouped)
        title = String(ct.ios.PageTitle())
        for page in 0..<ct.ios.SettingsPageCount() {
            let rows = (0..<ct.ios.SettingsRowCount(page)).filter { ct.ios.SettingsRowSteppable(page, $0) }
            if !rows.isEmpty {
                sections.append((page, rows))
            }
        }
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                                            action: #selector(done))
    }

    @objc private func done() { dismiss(animated: true) }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    override func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(ct.ios.SettingsPageName(sections[section].page))
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        section + 1 == sections.count ? "In the game these are under Options: press SELECT. Changes are saved at once."
                                      : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "row")
            ?? UITableViewCell(style: .default, reuseIdentifier: "row")
        cell.selectionStyle = .none
        let page = sections[path.section].page, row = sections[path.section].rows[path.row]
        var content = UIListContentConfiguration.subtitleCell()
        content.text = String(ct.ios.SettingsRowLabel(page, row))
        content.secondaryText = String(ct.ios.SettingsRowHelp(page, row))
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content

        let tag = path.section * 1000 + path.row
        let previous = UIButton(type: .system)
        previous.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        previous.addTarget(self, action: #selector(stepBack(_:)), for: .touchUpInside)
        let next = UIButton(type: .system)
        next.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        next.addTarget(self, action: #selector(stepOn(_:)), for: .touchUpInside)
        for button in [previous, next] {
            button.tag = tag
            button.tintColor = accent
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        }
        let value = UILabel()
        value.text = String(ct.ios.SettingsRowValue(page, row))
        value.textAlignment = .center
        value.font = .monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        value.adjustsFontSizeToFitWidth = true
        value.minimumScaleFactor = 0.6
        let stepper = UIStackView(arrangedSubviews: [previous, value, next])
        stepper.frame = CGRect(x: 0, y: 0, width: 190, height: 44)
        cell.accessoryView = stepper
        return cell
    }

    private func step(_ button: UIButton, _ direction: Int32) {
        let path = IndexPath(row: button.tag % 1000, section: button.tag / 1000)
        let page = sections[path.section].page, row = sections[path.section].rows[path.row]
        switch ct.ios.SettingsStep(page, row, direction) {
        case .Unchanged:
            return
        case .NotSaved:
            present(alert("Settings not saved",
                          "The change applies until the app closes, but config.json could not be written."),
                    animated: true)
        default:
            break
        }
        tableView.reloadRows(at: [path], with: .none)
    }

    @objc private func stepBack(_ button: UIButton) { step(button, -1) }

    @objc private func stepOn(_ button: UIButton) { step(button, 1) }
}

private final class LauncherController: UIViewController, UIDocumentPickerDelegate {
    var started = false

    private let root: String
    private var image: String?
    // A disc image chosen in Files stays readable only between these calls.
    private var scoped: URL?
    private var timer: Timer?
    private var background: UIBackgroundTaskIdentifier = .invalid

    private let statusIcon = UIImageView()
    private let statusTitle = LauncherController.label(18, .semibold, .white)
    private let statusBody = LauncherController.label(15, .regular, .secondaryLabel)
    private let progress = UIProgressView(progressViewStyle: .default)
    private let percent = LauncherController.label(13, .medium, .secondaryLabel)
    private let primary = makeButton("Play", "play.fill", primary: true)
    private let secondary = makeButton("Choose Disc Image…", "folder", primary: false)
    private var buttons = UIStackView()

    init(root: String) {
        self.root = root
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    private static func label(_ size: CGFloat, _ weight: UIFont.Weight, _ colour: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = colour
        label.numberOfLines = 0
        return label
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.05, green: 0.06, blue: 0.09, alpha: 1)
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.16, green: 0.11, blue: 0.20, alpha: 1).cgColor,
                           UIColor(red: 0.04, green: 0.05, blue: 0.08, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradient, at: 0)

        // The left column: the icon, the title and what the app needs.
        let icon = UIImageView(image: UIImage(named: "AppIcon60x60") ?? UIImage(systemName: "gamecontroller.fill"))
        icon.tintColor = accent
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 22
        icon.layer.masksToBounds = true
        icon.widthAnchor.constraint(equalToConstant: 96).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 96).isActive = true
        let title = LauncherController.label(34, .bold, .white)
        title.text = "Dark Chronicle"
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let subtitle = LauncherController.label(15, .regular, .secondaryLabel)
        subtitle.text = "Dark Cloud 2 on \(deviceName) · ChronicleTwo \(version)"
        let notice = LauncherController.label(12, .regular, .tertiaryLabel)
        notice.text = "Needs your own copy of the game. No game data comes with this app."
        let left = UIStackView(arrangedSubviews: [icon, title, subtitle, notice])
        left.axis = .vertical
        left.alignment = .leading
        left.spacing = 10
        left.setCustomSpacing(18, after: icon)

        // The right column: the data's state, then what to do about it.
        statusIcon.contentMode = .scaleAspectFit
        statusIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true
        statusIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true
        let header = UIStackView(arrangedSubviews: [statusIcon, statusTitle])
        header.spacing = 10
        header.alignment = .center
        progress.progressTintColor = accent
        percent.font = .monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        let card = UIStackView(arrangedSubviews: [header, statusBody, progress, percent])
        card.axis = .vertical
        card.spacing = 10
        card.isLayoutMarginsRelativeArrangement = true
        card.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        card.backgroundColor = UIColor(white: 1, alpha: 0.07)
        card.layer.cornerRadius = 16

        primary.addTarget(self, action: #selector(primaryTapped), for: .touchUpInside)
        secondary.addTarget(self, action: #selector(secondaryTapped), for: .touchUpInside)
        let settings = makeButton("Settings", "gearshape", primary: false)
        settings.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        let help = makeButton("Help", "questionmark.circle", primary: false)
        help.addTarget(self, action: #selector(showHelp), for: .touchUpInside)
        let small = UIStackView(arrangedSubviews: [settings, help])
        small.spacing = 10
        small.distribution = .fillEqually
        buttons = UIStackView(arrangedSubviews: [primary, secondary, small])
        buttons.axis = .vertical
        buttons.spacing = 10

        let right = UIStackView(arrangedSubviews: [card, buttons])
        right.axis = .vertical
        right.spacing = 16

        // A small landscape iPhone is short: the right column scrolls rather than clip.
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = false
        scroll.showsVerticalScrollIndicator = false
        right.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(right)

        left.translatesAutoresizingMaskIntoConstraints = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(left)
        view.addSubview(scroll)
        let safe = view.safeAreaLayoutGuide
        let centred = right.centerYAnchor.constraint(equalTo: scroll.frameLayoutGuide.centerYAnchor)
        centred.priority = .defaultLow
        NSLayoutConstraint.activate([
            left.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 32),
            left.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            left.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.38),
            scroll.leadingAnchor.constraint(equalTo: left.trailingAnchor, constant: 32),
            scroll.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -32),
            scroll.topAnchor.constraint(equalTo: safe.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            right.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            right.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            right.topAnchor.constraint(greaterThanOrEqualTo: scroll.contentLayoutGuide.topAnchor, constant: 16),
            right.bottomAnchor.constraint(lessThanOrEqualTo: scroll.contentLayoutGuide.bottomAnchor, constant: -16),
            right.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor),
            scroll.contentLayoutGuide.heightAnchor.constraint(greaterThanOrEqualTo: scroll.frameLayoutGuide.heightAnchor),
            centred,
        ])

        // Back from the Files app, the disc image the player copied there is found without a tap.
        NotificationCenter.default.addObserver(self, selector: #selector(refresh),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        refresh()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.sublayers?.first?.frame = view.bounds
    }

    override var prefersStatusBarHidden: Bool { true }

    override var prefersHomeIndicatorAutoHidden: Bool { true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }

    private var dataMissing: Bool { ct.ios.DataMissing(std.string(root)) }

    private func setStatus(_ symbol: String, _ colour: UIColor, _ title: String, _ body: String) {
        statusIcon.image = UIImage(systemName: symbol)
        statusIcon.tintColor = colour
        statusTitle.text = title
        statusBody.text = body
    }

    // Shows what the data's state calls for: Play once it is current, otherwise the way to it.
    @objc private func refresh() {
        if timer != nil {
            return
        }
        let found = String(ct.ios.DiscImage())
        image = found.isEmpty ? nil : found
        progress.isHidden = true
        percent.isHidden = true
        buttons.isHidden = false
        if !dataMissing {
            setStatus("checkmark.circle.fill", .systemGreen, "Ready to play", "The game data is extracted and current.")
            setTitle(primary, "Play", "play.fill")
            setTitle(secondary, "Extract Again…", "arrow.clockwise")
        } else if let image {
            setStatus("opticaldisc", accent, "Disc image found",
                      "\(fileName(image)) is in the app's folder. Extract the game data from it once to play: it takes "
                          + "several minutes.")
            setTitle(primary, "Extract Game Data", "square.and.arrow.down")
            setTitle(secondary, "Choose Another Disc Image…", "folder")
        } else {
            setStatus("opticaldisc", accent, "First, the game data",
                      "The game plays from the data of your own Dark Chronicle disc (PS2).\n"
                          + "1. Choose its disc image (.iso) in Files, or copy it into Files › On My \(deviceName) › "
                          + "Dark Chronicle.\n"
                          + "2. Extract the game data, once. The disc image is not needed after.")
            setTitle(primary, "Choose Disc Image…", "folder")
            secondary.isHidden = true
            return
        }
        secondary.isHidden = false
    }

    private func fileName(_ path: String) -> String { (path as NSString).lastPathComponent }

    @objc private func primaryTapped() {
        if !dataMissing {
            started = true
        } else if let image {
            extract(image)
        } else {
            chooseImage()
        }
    }

    @objc private func secondaryTapped() {
        if dataMissing {
            chooseImage()
            return
        }
        let sheet = UIAlertController(
            title: "Extract the game data again?",
            message: "This replaces the extracted data, for example after an update asks for it. Saves and settings "
                + "are kept.",
            preferredStyle: .alert)
        if let image {
            sheet.addAction(UIAlertAction(title: "From \(fileName(image))", style: .default) { [weak self] _ in
                self?.extract(image)
            })
        }
        sheet.addAction(UIAlertAction(title: "Choose Disc Image…", style: .default) { [weak self] _ in
            self?.chooseImage()
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }

    private func chooseImage() {
        var types: [UTType] = [.diskImage]
        if let iso = UTType(filenameExtension: "iso") {
            types.insert(iso, at: 0)
        }
        // Opened in place: a copy of a disc image of several gigabytes would need the space twice.
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: false)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        if url.startAccessingSecurityScopedResource() {
            scoped = url
        }
        extract(url.withUnsafeFileSystemRepresentation { String(cString: $0!) })
    }

    private func extract(_ image: String) {
        ct.ios.ExtractBegin(std.string(image), std.string(root))
        // The screen must stay on through the extraction: a locked device suspends the app. A trip to the
        // background gets the little time iOS grants before it suspends it too.
        UIApplication.shared.isIdleTimerDisabled = true
        background = UIApplication.shared.beginBackgroundTask(withName: "Extract the game data") { [weak self] in
            MainActor.assumeIsolated { self?.endBackgroundTask() }
        }
        setStatus("gearshape.2.fill", accent, "Extracting from \(fileName(image))",
                  "This takes several minutes. Keep the app open and the screen on.")
        progress.isHidden = false
        percent.isHidden = false
        progress.progress = 0
        percent.text = "Starting…"
        buttons.isHidden = true
        // The timer fires on the main run loop.
        let timer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.tick() }
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func endBackgroundTask() {
        if background != .invalid {
            UIApplication.shared.endBackgroundTask(background)
            background = .invalid
        }
    }

    private func tick() {
        let extraction = ct.ios.ExtractPoll()
        if extraction.running {
            progress.setProgress(extraction.fraction, animated: true)
            percent.text = "\(Int(extraction.fraction * 100))%  ·  \(String(extraction.stage))"
            return
        }
        timer?.invalidate()
        timer = nil
        scoped?.stopAccessingSecurityScopedResource()
        scoped = nil
        UIApplication.shared.isIdleTimerDisabled = false
        endBackgroundTask()
        refresh()
        let failure = String(extraction.failure)
        if failure.isEmpty {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            return
        }
        present(alert("The game data could not be extracted",
                      "\(failure)\n\nCheck that the disc image is a whole Dark Chronicle (PS2) disc and that the "
                          + "\(deviceName) has free storage for the extracted data."),
                animated: true)
    }

    @objc private func showSettings() {
        let navigation = UINavigationController(rootViewController: SettingsController())
        navigation.modalPresentationStyle = .formSheet
        present(navigation, animated: true)
    }

    @objc private func showHelp() {
        present(alert("Getting started",
                      "Dark Chronicle plays from the data of your own Dark Chronicle (PS2) disc.\n\n"
                          + "1. Make a disc image (.iso) of your disc.\n"
                          + "2. Put it on this \(deviceName): tap Choose Disc Image and pick it in Files, or copy it "
                          + "into Files › On My \(deviceName) › Dark Chronicle.\n"
                          + "3. Tap Extract Game Data. It takes several minutes; keep the app open and the screen on.\n\n"
                          + "Under LiveContainer, copy the image into LiveContainer's folder: Data › Application › the "
                          + "game's folder › Documents, or use Choose Disc Image.\n\n"
                          + "The settings are also in the game: Options, then SELECT. Logs are in Files › Dark "
                          + "Chronicle › chronicletwo › logs."),
                animated: true)
    }
}

@_cdecl("IosLauncherRunAt")
public func iosLauncherRunAt(_ dataRoot: UnsafePointer<CChar>) {
    let root = String(cString: dataRoot)
    // The game calls this on the main thread.
    MainActor.assumeIsolated { autoreleasepool {
        let controller = LauncherController(root: root)
        let scene = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        let window = scene.map { UIWindow(windowScene: $0) } ?? UIWindow(frame: UIScreen.main.bounds)
        window.overrideUserInterfaceStyle = .dark
        window.tintColor = accent
        // Above the window SDL may show while it starts.
        window.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.normal.rawValue + 1)
        window.rootViewController = controller
        window.makeKeyAndVisible()
        while !controller.started {
            CFRunLoopRunInMode(.defaultMode, 0.05, true)
        }
        window.isHidden = true
        window.rootViewController = nil
    } }
}
