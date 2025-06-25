import Foundation

struct ScanLocation {
    let directoryURL: URL
    let title: String
    let description: String
    let searchDepth: Int

    private init(title: String, directoryURL: URL, description: String, searchDepth: Int) {
        self.title = title
        self.directoryURL = directoryURL
        self.description = description
        self.searchDepth = searchDepth
    }
}

extension ScanLocation {
    public static let applicationDirectory: ScanLocation = ScanLocation(
        title: "Applications",
        directoryURL: .applicationDirectory,
        description: "Application Directory",
        searchDepth: 1
    )
    public static let applicationSupportDirectory: ScanLocation = ScanLocation(
        title: "Application Support",
        directoryURL: .applicationSupportDirectory,
        description: "Application Support Directory",
        searchDepth: 1
    )
    public static let cachesDirectory: ScanLocation = ScanLocation(
        title: "Caches",
        directoryURL: .cachesDirectory,
        description: "Caches Directory",
        searchDepth: 1
    )
    public static let libraryDirectory: ScanLocation = ScanLocation(
        title: "Library",
        directoryURL: .libraryDirectory,
        description: "Library Directory",
        searchDepth: 1
    )
}
/*
Possible directories:
  // "/Applications/",
            // "~/Library/Application Support",
            // "/Library/Caches/",
            // "~/Library/Caches/",
            // "~/Library/Internet Plug-Ins/",
            // "~/Library/",
            // "~/Library/Preferences/",
            // "~/Library/Application Support/CrashReporter/",
            // "~/Library/Saved Application State/",
            // "~/",
*/
