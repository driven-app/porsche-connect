import Foundation
import os.log

// MARK: - Static Constants

let kLibraryName = "PorscheConnect"
let kDefaultTestTimeout: TimeInterval = 10
let kBlankString = ""
let kBlankData: Data = "".data(using: .utf8)!
let kTestServerPort = 8080

// MARK: - Logging

let AuthLogger = Logger(subsystem: kLibraryName, category: "Auth")

// MARK: - HTTP Status Codes

enum HttpStatusCode: Int, Error {
  // 100 Informational
  case Continue = 100
  case SwitchingProtocols
  case Processing

  // 200 Success
  case OK = 200
  case Created
  case Accepted
  case NonAuthoritativeInformation
  case NoContent
  case ResetContent
  case PartialContent
  case MultiStatus
  case AlreadyReported
  case IMUsed = 226

  // 300 Redirection
  case MultipleChoices = 300
  case MovedPermanently
  case Found
  case SeeOther
  case NotModified
  case UseProxy
  case SwitchProxy
  case TemporaryRedirect
  case PermanentRedirect

  // 400 Client Error
  case BadRequest = 400
  case Unauthorized
  case PaymentRequired
  case Forbidden
  case NotFound
  case MethodNotAllowed
  case NotAcceptable
  case ProxyAuthenticationRequired
  case RequestTimeout
  case Conflict
  case Gone
  case LengthRequired
  case PreconditionFailed
  case PayloadTooLarge
  case URITooLong
  case UnsupportedMediaType
  case RangeNotSatisfiable
  case ExpectationFailed
  case ImATeapot
  case MisdirectedRequest = 421
  case UnprocessableEntity
  case Locked
  case FailedDependency
  case UpgradeRequired = 426
  case PreconditionRequired = 428
  case TooManyRequests
  case RequestHeaderFieldsTooLarge = 431
  case UnavailableForLegalReasons = 451

  // 500 Server Error
  case InternalServerError = 500
  case NotImplemented
  case BadGateway
  case ServiceUnavailable
  case GatewayTimeout
  case HTTPVersionNotSupported
  case VariantAlsoNegotiates
  case InsufficientStorage
  case LoopDetected
  case NotExtended = 510
  case NetworkAuthenticationRequired

  var localizedDescription: String {
    return String(rawValue)
  }
}
