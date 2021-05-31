// swiftlint:disable all
import Amplify
import Foundation

extension AdminUserss {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case email
    case phone
    case password
    case status
    case deleted
    case created
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let adminUserss = AdminUserss.keys
    
    model.pluralName = "AdminUsersses"
    
    model.fields(
      .id(),
      .field(adminUserss.name, is: .optional, ofType: .string),
      .field(adminUserss.email, is: .optional, ofType: .string),
      .field(adminUserss.phone, is: .optional, ofType: .string),
      .field(adminUserss.password, is: .optional, ofType: .string),
      .field(adminUserss.status, is: .optional, ofType: .bool),
      .field(adminUserss.deleted, is: .optional, ofType: .bool),
      .field(adminUserss.created, is: .optional, ofType: .string)
    )
    }
}