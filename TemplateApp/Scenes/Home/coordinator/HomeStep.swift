import RxFlow
import RxSwift

enum HomeStep: Step {
    case start

    case toUser(user: User)
    case toCloseUser
    case toAbout
    case toSettings
    case toCreate
}

extension HomeStep {
    var stepDescription: String {
        switch self {
        case .start:
            return "Created"
        case let .toUser(user):
            return "Open user with name \(user.name)"
        case .toCloseUser:
            return "Close open user"
        case .toAbout:
            return "Navigate to about"
        case .toSettings:
            return "Navigate to settings"
        case .toCreate:
            return "Navigate to create user"
        }
    }
}
