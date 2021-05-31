// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "c44e2c07b642b726f9beb0bc35ff7277"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Users.self)
    ModelRegistry.register(modelType: Contents.self)
    ModelRegistry.register(modelType: ContentUnit.self)
    ModelRegistry.register(modelType: AdminUserss.self)
  }
}