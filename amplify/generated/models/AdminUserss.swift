// swiftlint:disable all
import Amplify
import Foundation

public struct AdminUserss: Model {
  public let id: String
  public var name: String?
  public var email: String?
  public var phone: String?
  public var password: String?
  public var status: Bool?
  public var deleted: Bool?
  public var created: String?
  
  public init(id: String = UUID().uuidString,
      name: String? = nil,
      email: String? = nil,
      phone: String? = nil,
      password: String? = nil,
      status: Bool? = nil,
      deleted: Bool? = nil,
      created: String? = nil) {
      self.id = id
      self.name = name
      self.email = email
      self.phone = phone
      self.password = password
      self.status = status
      self.deleted = deleted
      self.created = created
  }
}