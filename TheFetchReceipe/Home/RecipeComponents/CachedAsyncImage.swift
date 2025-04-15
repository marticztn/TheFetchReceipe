import SwiftUI

struct CachedAsyncImage: View {
    
    @StateObject private var loader: ImageLoader
    
    private let placeholder: AnyView
    private let content: (UIImage) -> AnyView
    
    init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> some View,
        @ViewBuilder content: @escaping (UIImage) -> some View
    ) {
        self._loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = AnyView(placeholder())
        self.content = { image in AnyView(content(image)) }
    }
    
    var body: some View {
        ZStack {
            if let image = loader.image {
                content(image)
            } else {
                placeholder
            }
        }
        .task {
            await loader.load()
        }
    }
}
