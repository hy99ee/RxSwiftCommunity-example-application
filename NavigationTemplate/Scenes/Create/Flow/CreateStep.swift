import RxFlow

enum CreateStep: Step {
    case start
    case create(user: User)
    case close
}
