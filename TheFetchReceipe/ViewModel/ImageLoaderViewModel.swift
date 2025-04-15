import SwiftUI

final class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private var url: URL?
    
    private static let memoryCache = NSCache<NSString, UIImage>()
    private static let cacheFolderName = "RecipeImageCache"
    
    init(url: URL?) {
        self.url = url
    }
    
    func load() async {
        guard let url = url else { return }
        let cacheKey = url.absoluteString as NSString
        
        // Try to load the image from the memory cache first
        if let cachedImage = Self.memoryCache.object(forKey: cacheKey) {
            await MainActor.run {
                self.image = cachedImage
            }
            return
        }
        
        // If there's no memory cache found, check for disk cache
        if let diskCachedImage = await loadImageFromDisk(url: url) {
            Self.memoryCache.setObject(diskCachedImage, forKey: cacheKey)
            await MainActor.run {
                self.image = diskCachedImage
            }
            return
        }
        
        // If both cannot be found, treat it as a new image,
        // download from the provided URL, then cache it to the memory/disk
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImg = UIImage(data: data) {
                Self.memoryCache.setObject(downloadedImg, forKey: cacheKey)
                await MainActor.run {
                    self.image = downloadedImg
                }
                await saveImageToDisk(image: downloadedImg, url: url)
            }
        } catch {
            print("[ERROR] ImageLoader - Failed to download image from URL: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private functions
    
    private func getCacheDirURL() -> URL? {
        let fileManager = FileManager.default
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let folderURL = cacheDir.appendingPathComponent(Self.cacheFolderName, isDirectory: true)
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("[ERROR] ImageLoader - Failed to create cache folder: \(error.localizedDescription)")
                return nil
            }
        }
        
        return folderURL
    }
    
    private func getDiskCachePath(url: URL) -> URL? {
        guard let cacheDir = getCacheDirURL() else { return nil }
        let fileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return cacheDir.appendingPathComponent(fileName)
    }
    
    private func saveImageToDisk(image: UIImage, url: URL) async {
        guard let fileURL = getDiskCachePath(url: url) else { return }
        
        // Use JPEG for best efficiency
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("[ERROR] ImageLoader - Failed to save image to disk: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadImageFromDisk(url: URL) async -> UIImage? {
        guard let fileURL = getDiskCachePath(url: url) else { return nil }
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                return UIImage(data: data)
            } catch {
                print("[ERROR] ImageLoader - Failed to load image from disk: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
