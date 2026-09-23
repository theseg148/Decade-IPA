import Foundation
import WebKit
import UniformTypeIdentifiers

final class LocalSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else {
            urlSchemeTask.didFailWithError(NSError(domain: "Decade", code: 1))
            return
        }

        let rawPath = url.path.isEmpty ? "/index.html" : url.path
        let cleanPath = rawPath.removingPercentEncoding?.trimmingCharacters(in: CharacterSet(charactersIn: "/")) ?? "index.html"

        guard !cleanPath.contains(".."),
              let webRoot = Bundle.main.resourceURL?.appendingPathComponent("Web", isDirectory: true) else {
            urlSchemeTask.didFailWithError(NSError(domain: "Decade", code: 2))
            return
        }

        var fileURL = webRoot.appendingPathComponent(cleanPath)
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory), isDirectory.boolValue {
            fileURL.appendPathComponent("index.html")
        }

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            let data = Data("Not Found".utf8)
            let response = URLResponse(url: url, mimeType: "text/plain", expectedContentLength: data.count, textEncodingName: "utf-8")
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
            return
        }

        do {
            let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            let mime = mimeType(for: fileURL.pathExtension)
            let response = URLResponse(url: url, mimeType: mime, expectedContentLength: data.count, textEncodingName: textEncoding(for: mime))
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        } catch {
            urlSchemeTask.didFailWithError(error)
        }
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}

    private func mimeType(for ext: String) -> String {
        if let type = UTType(filenameExtension: ext), let mime = type.preferredMIMEType {
            return mime
        }
        switch ext.lowercased() {
        case "js": return "text/javascript"
        case "json": return "application/json"
        case "wasm": return "application/wasm"
        case "svg": return "image/svg+xml"
        case "mp3": return "audio/mpeg"
        case "mp4": return "video/mp4"
        default: return "application/octet-stream"
        }
    }

    private func textEncoding(for mime: String) -> String? {
        if mime.hasPrefix("text/") || mime == "application/json" || mime == "text/javascript" {
            return "utf-8"
        }
        return nil
    }
}
