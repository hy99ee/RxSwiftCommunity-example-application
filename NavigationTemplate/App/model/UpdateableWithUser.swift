import Foundation

protocol UpdateableWithUser: AnyObject {
    var user: User? { get set }
}
