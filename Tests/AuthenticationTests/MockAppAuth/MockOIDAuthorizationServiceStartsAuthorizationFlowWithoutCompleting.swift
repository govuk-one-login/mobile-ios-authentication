@preconcurrency import AppAuthCore
import UIKit

///
/// Use this ``OIDAuthorizationService`` to mock ``present(_:presenting:prefersEphemeralSession:callback)`` which simulates how ``OIDAuthorizationService``
/// will **fail in case the app failed to register with universal links** [^1].
///
/// Universal links may fail to register with an app for [a number of reasons](https://developer.apple.com/documentation/technotes/tn3155-debugging-universal-links).
///
/// **This mock helps you write a test where your code is expected** to call ``resumeExternalUserAgentFlow(with:)`` on the returned ``OIDExternalUserAgentSession`` instance.
///
/// [1]: *Reportedly* we have seen cases where the ``ASWebAuthenticationSession`` fails to have its ``completionHandler`` called
/// in case the ``callbackURLScheme`` used is **https** (which is the scheme used by the `redirectURL`).
///
/// - SeeAlso: https://govukverify.atlassian.net/browse/DCMAW-20288 for a ticket as it relates to the reliability of UI Tests.
/// These are *seemingly* the only cases for which we have seen evidence of universal links failing (thus the the UI test failing) due to failures to the associated domain
/// not being registered.
///
/// - SeeAlso: https://developer.apple.com/videos/play/wwdc2020/10098/?time=890 'After the app is downloaded and installed the system checks its entitlements and sees that
/// it needs data from one or more apple-app-site-association files. The device opens a connection to the web server where that file is hosted in order to download it.
/// The apple-app-site-association file makes its way from the web service to the device, is parsed by the associated domains deamon and the app's universal links become active.
/// But, what if there is a problem with the download? [...] the data won't make it to the device [...] this leaves the device in an inconsistent state, where the app is installed
/// but its universal links and other Associated Domains data are not available. This state can persist for hours or days, until the system next attempts to
/// update the data for that app."
///
@MainActor
// swiftlint:disable:next type_name
final class MockOIDAuthorizationServiceStartsAuthorizationFlowWithoutCompleting: OIDAuthorizationService {
    static func mock() -> MockOIDAuthorizationServiceStartsAuthorizationFlowWithoutCompleting.Type {
        MockOIDAuthorizationServiceStartsAuthorizationFlowWithoutCompleting.self
    }

    static func stub(
        authorizationRequest request: OIDAuthorizationRequest,
        externalUserAgent: any OIDExternalUserAgent
    ) {
        Self.stubRequests[request.configuration.authorizationEndpoint] = (request, externalUserAgent)
    }

    private static var stubRequests: [URL: (OIDAuthorizationRequest, any OIDExternalUserAgent)] = [:]

    override static func present(
        _ request: OIDAuthorizationRequest,
        presenting presentingViewController: UIViewController,
        prefersEphemeralSession: Bool,
        callback: @escaping OIDAuthorizationCallback
    ) -> any OIDExternalUserAgentSession {
        guard let (authorizationRequest, externalUserAgent) = Self.stubRequests[request.configuration.authorizationEndpoint] else {
            return MockOIDExternalUserAgentSessionResumeExternalUserAgentFlow()
        }

        return OIDAuthorizationService.present(
            authorizationRequest,
            externalUserAgent: externalUserAgent,
            callback: callback
        )
    }
}

@MainActor
final class MockOIDExternalUserAgent: NSObject, @preconcurrency OIDExternalUserAgent {
    static let authorizationFlowStarted = Notification.Name("MockOIDExternalUserAgent.authorizationFlowStarted")

    func present(
        _ request: any OIDExternalUserAgentRequest,
        session: any OIDExternalUserAgentSession
    ) -> Bool {
        NotificationCenter.default.post(name: MockOIDExternalUserAgent.authorizationFlowStarted, object: self)
        return true
    }

    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        completion()
    }
}
