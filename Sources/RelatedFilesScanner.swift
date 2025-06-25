import Foundation

struct RelatedFilesScanner {
    let appName: String
    let keywords: [String]

    init(appName: String) {
        self.appName = appName
        self.keywords = Self.generateKeywords(for: appName)
    }

    private static func generateKeywords(for name: String) -> [String] {
        var keywords: Set = [name]

        keywords.formUnion(name.components(separatedBy: .whitespacesAndNewlines))
        keywords.insert(name.trimmingCharacters(in: .whitespacesAndNewlines))

        return Array(keywords)
    }

    func searchInDirectory(path: URL, depth: Int = 1) -> [ScanHit] {
        var hits: [ScanHit] = []

        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(
                at: path, includingPropertiesForKeys: [.isDirectoryKey, .nameKey])
            for file in files {
                let resourceValues = try file.resourceValues(forKeys: [.isDirectoryKey, .nameKey])

                // Actual search
                if let keyword = searchFor(keywords, in: resourceValues.name ?? "") {
                    let hit = ScanHit(fileUrl: file, foundWithKeyWord: keyword)
                    hits.append(hit)
                    continue
                }

                if resourceValues.isDirectory == true {
                    // file is a directory
                    if depth - 1 > 0 {
                        hits.append(
                            contentsOf: searchInDirectory(path: file, depth: depth - 1))
                    }
                }
            }
        } catch {
            print(
                "Error searching in \(path.path(percentEncoded: false)): \(error.localizedDescription)"
            )
        }

        return hits
    }

    private func searchFor(_ keywords: [String], in name: String) -> String? {
        for word in keywords {
            if name.range(of: word, options: .caseInsensitive) != nil {
                return word
            }
        }
        return nil
    }
}
