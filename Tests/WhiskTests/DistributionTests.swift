import Testing

@testable import Whisk

@Suite struct DistributionRules {
    @Test func only_the_developer_id_build_checks_for_updates() {
        #expect(Distribution.developerID.checksForUpdates)
        #expect(!Distribution.appStore.checksForUpdates)
        #expect(!Distribution.localized.checksForUpdates)
    }

    @Test func the_test_build_matches_its_distribution_flag() {
        #if WHISK_LOCALIZED
            #expect(Distribution.current == .localized)
        #elseif APP_STORE
            #expect(Distribution.current == .appStore)
        #else
            #expect(Distribution.current == .developerID)
        #endif
    }
}
