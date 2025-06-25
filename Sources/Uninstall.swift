import ArgumentParser
import Foundation

@main
struct Uninstall: ParsableCommand {

    var scanLocations: [ScanLocation] {
        [
            .applicationDirectory,
            .applicationSupportDirectory,
            .cachesDirectory,
            .libraryDirectory,
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

        let scanner = RelatedFilesScanner(appName: appName)
        var results: [ScanHit] = []

        for location in scanLocations {
            let result = scanner.searchInDirectory(
                path: location.directoryURL, depth: location.searchDepth)
            print("Found \(result.count) related file(s) in \(location.title)")
            for hit in result {
                print(
                    "Search word: \(hit.foundWithKeyWord), location: \(hit.fileUrl.path(percentEncoded: false))"
                )
            }
            results.append(contentsOf: result)
        }
    }

    enum UninstallerCLIError: Error {
        case fileDoesNotExist
    }
}
