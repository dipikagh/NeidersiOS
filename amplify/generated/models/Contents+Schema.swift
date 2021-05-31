// swiftlint:disable all
import Amplify
import Foundation

extension Contents {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case subject
    case keyword
    case author
    case language
    case organization_name
    case content_type
    case content_name
    case content_url
    case uploaded_by
    case upload_time
    case status
    case deleted
    case created
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let contents = Contents.keys
    
    model.pluralName = "Contents"
    
    model.fields(
      .id(),
      .field(contents.title, is: .optional, ofType: .string),
      .field(contents.subject, is: .optional, ofType: .string),
      .field(contents.keyword, is: .optional, ofType: .string),
      .field(contents.author, is: .optional, ofType: .string),
      .field(contents.language, is: .optional, ofType: .string),
      .field(contents.organization_name, is: .optional, ofType: .string),
      .field(contents.content_type, is: .optional, ofType: .string),
      .field(contents.content_name, is: .optional, ofType: .string),
      .field(contents.content_url, is: .optional, ofType: .string),
      .field(contents.uploaded_by, is: .optional, ofType: .string),
      .field(contents.upload_time, is: .optional, ofType: .string),
      .field(contents.status, is: .optional, ofType: .bool),
      .field(contents.deleted, is: .optional, ofType: .bool),
      .field(contents.created, is: .optional, ofType: .string)
    )
    }
}