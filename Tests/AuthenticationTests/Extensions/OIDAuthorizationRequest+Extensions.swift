@preconcurrency import AppAuthCore

extension OIDAuthorizationRequest {
    func stubRedirectURL(code: String = "test-code") -> URL {
        var redirect = URLComponents(url: self.redirectURL!, resolvingAgainstBaseURL: false)!
        redirect.queryItems = [URLQueryItem(name: "code", value: code)]
        if let state = self.state {
            redirect.queryItems?.append(URLQueryItem(name: "state", value: state))
        }

        return redirect.url!
    }

    func stubRedirectURL(error: String, description: String = "") -> URL {
        var redirect = URLComponents(url: self.redirectURL!, resolvingAgainstBaseURL: false)!
        redirect.queryItems = [URLQueryItem(name: "error", value: error),
                               URLQueryItem(name: "error_description", value: description)]

        return redirect.url!
    }

    func stubRedirectURL(error: OIDError, description: String = "") -> URL {
        return stubRedirectURL(error: error.rawValue, description: description)
    }
}
