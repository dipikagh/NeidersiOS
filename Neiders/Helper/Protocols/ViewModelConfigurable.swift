
import Foundation

protocol ViewModelConfigurable {
    
    associatedtype ViewModelType
    
    var viewModel: ViewModelType? { get }
    
    func configureFrom(_ viewModel: ViewModelType?, indexPath:IndexPath)
}
