// swiftlint:disable all
import Amplify
import Foundation

extension ContentUnit {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case course_id
    case unit_number
    case title
    case keyword
    case language
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
    let contentUnit = ContentUnit.keys
    
    model.pluralName = "ContentUnits"
    
    model.fields(
      .id(),
      .field(contentUnit.course_id, is: .optional, ofType: .string),
      .field(contentUnit.unit_number, is: .optional, ofType: .string),
      .field(contentUnit.title, is: .optional, ofType: .string),
      .field(contentUnit.keyword, is: .optional, ofType: .string),
      .field(contentUnit.language, is: .optional, ofType: .string),
      .field(contentUnit.content_type, is: .optional, ofType: .string),
      .field(contentUnit.content_name, is: .optional, ofType: .string),
      .field(contentUnit.content_url, is: .optional, ofType: .string),
      .field(contentUnit.uploaded_by, is: .optional, ofType: .string),
      .field(contentUnit.upload_time, is: .optional, ofType: .string),
      .field(contentUnit.status, is: .optional, ofType: .bool),
      .field(contentUnit.deleted, is: .optional, ofType: .bool),
      .field(contentUnit.created, is: .optional, ofType: .string)
    )
    }
}