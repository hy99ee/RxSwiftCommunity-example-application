import RxCocoa
import RxSwift
import WidgetKit

final class AppRepository: Repository<User> {
    override init() {
        super.init()

        elements = []
    }
    
    override func add(_ element: User) {
        super.add(element)

        if #available(iOS 14.0, *) {
            UserDefaults(suiteName: "group.com.template")!.set(element.name, forKey: "last_add_user")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
