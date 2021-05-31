// swiftlint:disable all
import Amplify
import Foundation

public struct Contents: Model {
  public let id: String
  public var title: String?
  public var subject: String?
  public var keyword: String?
  public var author: String?
  public var language: String?
  public var organization_name: String?
  public var content_type: String?
  public var content_name: String?
  public var content_url: String?
  public var uploaded_by: String?
  public var upload_time: String?
  public var status: Bool?
  public var deleted: Bool?
  public var created: String?
  
  public init(id: String = UUID().uuidString,
      title: String? = nil,
      subject: String? = nil,
      keyword: String? = nil,
      author: String? = nil,
      language: String? = nil,
      organization_name: String? = nil,
      content_type: String? = nil,
      content_name: String? = nil,
      content_url: String? = nil,
      uploaded_by: String? = nil,
      upload_time: String? = nil,
      status: Bool? = nil,
      deleted: Bool? = nil,
      created: String? = nil) {
      self.id = id
      self.title = title
      self.subject = subject
      self.keyword = keyword
      self.author = author
      self.language = language
      self.organization_name = organization_name
      self.content_type = content_type
      self.content_name = content_name
      self.content_url = content_url
      self.uploaded_by = uploaded_by
      self.upload_time = upload_time
      self.status = status
      self.deleted = deleted
      self.created = created
  }
}