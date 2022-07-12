import RxFlow

enum CreateStep: Step {
    case start
    case saveStep(user: User)
    case closeTop
    case close
}
