import Foundation

@Observable
final class DiscoverViewModel {
    var items: [DiscoverItem] = DefaultDiscoverItems.all
}
