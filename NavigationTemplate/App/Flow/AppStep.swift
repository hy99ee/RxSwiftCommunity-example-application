import RxFlow

enum AppStep: Step {
    case toRoot

    case toHome

    case toCreate
    case fromCreate(user: User)

    case toSettings
}
