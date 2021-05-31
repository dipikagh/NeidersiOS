// swiftlint:disable all
import Amplify
import Foundation

extension Users {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case login_type
    case full_name
    case email
    case phone
    case password
    case otp
    case email_validation_token
    case email_validation_token_timestamp
    case forgot_password_token
    case forgot_password_token_timestamp
    case is_email_valid
    case is_phone_valid
    case status
    case deleted
    case created
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let users = Users.keys
    
    model.pluralName = "Users"
    
    model.fields(
      .id(),
      .field(users.login_type, is: .optional, ofType: .string),
      .field(users.full_name, is: .optional, ofType: .string),
      .field(users.email, is: .optional, ofType: .string),
      .field(users.phone, is: .optional, ofType: .string),
      .field(users.password, is: .optional, ofType: .string),
      .field(users.otp, is: .optional, ofType: .int),
      .field(users.email_validation_token, is: .optional, ofType: .string),
      .field(users.email_validation_token_timestamp, is: .optional, ofType: .string),
      .field(users.forgot_password_token, is: .optional, ofType: .string),
      .field(users.forgot_password_token_timestamp, is: .optional, ofType: .string),
      .field(users.is_email_valid, is: .optional, ofType: .bool),
      .field(users.is_phone_valid, is: .optional, ofType: .bool),
      .field(users.status, is: .optional, ofType: .bool),
      .field(users.deleted, is: .optional, ofType: .bool),
      .field(users.created, is: .optional, ofType: .string)
    )
    }
}