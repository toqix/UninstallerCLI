import ArgumentParser
import Foundation

@available(macOS 13.0, *)
@main
struct Uninstall: ParsableCommand {

    var scanLocations: [URL] {
        [
            .applicationDirectory,
            .applicationSupportDirectory,
            .cachesDirectory,
            .libraryDirectory,
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
        ]
    }

    @Argument(
        help: "Path to the .app executable to be removed.",
    )
    var filePath: String

    mutating func run() throws {
        print("Uninstalling \(filePath). Searching for related files.")

        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: filePath) else {
            throw UninstallerCLIError.fileDoesNotExist
        }

        let appName = fileManager.displayName(atPath: filePath)

        var wordsToSearch: [String] = [appName]
        wordsToSearch.append(contentsOf: appName.components(separatedBy: .whitespacesAndNewlines))
        wordsToSearch.append(appName.trimmingCharacters(in: .whitespacesAndNewlines))

        for location in scanLocations {
            do {
                let items = try fileManager.contentsOfDirectory(
                    at: location, includingPropertiesForKeys: [.nameKey])

                let hits = items.filter { fileUrl in
                    for word in wordsToSearch {
                        if fileUrl.path(percentEncoded: false).range(
                            of: word, options: .caseInsensitive) != nil
                        {
                            return true
                        }
                    }
                    return false
                }

                for hit in hits {
                    print("Found file at \(hit).")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    enum UninstallerCLIError: Error {
        case fileDoesNotExist
    }
}
