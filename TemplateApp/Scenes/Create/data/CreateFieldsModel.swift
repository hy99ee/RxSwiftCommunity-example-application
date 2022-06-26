import RxSwift
import RxCocoa
import Foundation

final class Form {
    let sections: [FormSection]
    init(sections: [FormSection]) {
        self.sections = sections
    }
}

final class FormSection {
    let items: [FormItem]
    init(items: [FormItem]) {
        self.items = items
    }
}

protocol FormItem {
    var text: PublishSubject<String> { get }
    var placeholder: String? { get }
}

struct TextInputFormItem: FormItem {
    let text: PublishSubject<String>
    let placeholder: String?
    
    init(placeholder: String = "Enter text ...") {
        self.placeholder = placeholder
        
        self.text = PublishSubject()
    }
    
}

//final class Note {
//    init(topic: String, text: String) {
//        self.topic = topic
//        self.text = text
//    }
//    
//    var topic: String = "" {
//        didSet {
//            print("Topic changed to \(topic).")
//        }
//    }
//    
//    var text: String = "" {
//        didSet {
//            print("Text changed to \(text).")
//        }
//    }
//}
