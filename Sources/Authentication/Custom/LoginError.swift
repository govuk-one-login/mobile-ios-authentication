enum LoginError: Error {
    case missingAuthorizationCode
    case inconsistentStateResponse
    case missingRedirectURI
}
