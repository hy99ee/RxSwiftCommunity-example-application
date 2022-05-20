import RxFlow
import RxSwift

enum HomeStep: Step {
    case start

    case toUser(user: User)
    case toAbout
    case toSettings
    case toCreate
}
