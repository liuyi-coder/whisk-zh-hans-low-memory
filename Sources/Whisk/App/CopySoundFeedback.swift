import AppKit
import Foundation

/// The short copy confirmation sounds offered in Settings.
enum CopySoundOption: String, CaseIterable, Identifiable, Codable {
    case tick
    case tick2
    case click
    case click2
    case pop
    case pop2
    case snap
    case tsk
    case du
    case beep
    case chime
    case ding
    case dong
    case chirp
    case xiaomiWaterDrop
    case xiaomiBirdCicada
    case xiaomiWindChime

    var id: String { rawValue }

    var fileName: String {
        switch self {
        case .xiaomiWaterDrop: "WaterDropNotificationDay1"
        case .xiaomiBirdCicada: "BirdCicadaNotificationDay1"
        case .xiaomiWindChime: "WindChime"
        default: "copy_\(rawValue)"
        }
    }

    var label: String {
        switch self {
        case .tick: localized("Short tick")
        case .tick2: localized("Woodblock tick")
        case .click: localized("Crisp click")
        case .click2: localized("Dry click")
        case .pop: localized("Soft pop")
        case .pop2: localized("Round pop")
        case .snap: localized("Quick snap")
        case .tsk: localized("Short tsk")
        case .du: localized("Low du")
        case .beep: localized("Digital beep")
        case .chime: localized("Light chime")
        case .ding: localized("Bell ding")
        case .dong: localized("Deep dong")
        case .chirp: localized("Rising chirp")
        case .xiaomiWaterDrop: localized("Xiaomi water drop")
        case .xiaomiBirdCicada: localized("Xiaomi bird and cicada")
        case .xiaomiWindChime: localized("Xiaomi wind chime")
        }
    }
}

/// Plays the selected copy confirmation sound. A sound that is still
/// playing is not interrupted by the next copy.
final class CopySoundFeedback: @unchecked Sendable {
    private let lock = NSLock()
    private var sound: NSSound?
    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func play(_ option: CopySoundOption) {
        guard let url = Self.soundURL(for: option, in: bundle) else { return }

        guard let next = NSSound(contentsOf: url, byReference: false) else { return }
        lock.lock()
        if sound?.isPlaying == true {
            lock.unlock()
            return
        }
        sound?.stop()
        sound = next
        lock.unlock()
        next.play()
    }

    /// SwiftPM copies processed resources into the bundle root. Resolve
    /// both the packaged location and the source-tree layout so preview and
    /// capture behave the same way during development and release.
    static func soundURL(for option: CopySoundOption, in bundle: Bundle = .main) -> URL? {
        let filename = "\(option.fileName).caf"
        if let url = bundle.url(forResource: option.fileName, withExtension: "caf") {
            return url
        }
        if let resourceURL = bundle.resourceURL {
            let packaged = resourceURL.appendingPathComponent(filename)
            if FileManager.default.fileExists(atPath: packaged.path) {
                return packaged
            }
            let resourceBundle =
                resourceURL.appendingPathComponent("Whisk_Whisk.bundle/Contents/Resources", isDirectory: true)
            let nested = resourceBundle.appendingPathComponent(filename)
            if FileManager.default.fileExists(atPath: nested.path) {
                return nested
            }
        }
        return nil
    }

    func stop() {
        lock.lock()
        sound?.stop()
        sound = nil
        lock.unlock()
    }
}
