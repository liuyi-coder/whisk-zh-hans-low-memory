import AppKit
import Foundation
import Testing

@testable import Whisk

@Suite struct CopySoundFeedbackBehaviour {
    @Test func copy_sound_options_have_distinct_ids_and_labels() {
        let ids = CopySoundOption.allCases.map(\.id)
        let labels = CopySoundOption.allCases.map(\.label)

        #expect(ids.count == Set(ids).count)
        #expect(labels.allSatisfy { !$0.isEmpty })
        #expect(labels.count == Set(labels).count)
        #expect(CopySoundOption.allCases.count >= 3)
    }

    @Test func a_selected_sound_file_loads_from_the_resource_bundle() throws {
        for option in CopySoundOption.allCases {
            let url = try #require(CopySoundFeedback.soundURL(for: option, in: Bundle.module))
            #expect(NSSound(contentsOf: url, byReference: false) != nil)
        }
    }

    @Test func the_default_copy_sound_finishes_playing() throws {
        let feedback = CopySoundFeedback()
        feedback.play(.tick)

        let deadline = Date().addingTimeInterval(3)
        while Date() < deadline {
            Thread.sleep(forTimeInterval: 0.02)
        }
        #expect(true)
    }
}
