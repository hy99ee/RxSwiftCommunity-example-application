import Foundation

struct User {
    let id: Int
    let name: String
    let age: Int

    static func create() -> User {
        User(
            id: Int.random(in: ClosedRange(uncheckedBounds: (lower: 0, upper: 100))),
            name: "Name",
            age: 99
        )
    }
}
