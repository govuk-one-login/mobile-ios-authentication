import CryptoKit
import DeviceCheck
import Networking

public enum AttestationError: Error {
    case attestKey
    case getAssertion
    case getChallenge
    case keyNotCreated
    case noKey
    case notVerified
    case network
    case serializingRequestBody
    case serializingChallenge
}

@available(iOS 14.0, *)
public final class AttestationService {
    private let service = DCAppAttestService.shared
    private let networkClient = NetworkClient()
    private var keyID: String?
    private var verificationSatisfied: Bool?
    
    public func generate() async throws {
        // Ensure device supports app attest.
        if service.isSupported {
            // Perform key generation.
            do {
                keyID = try await service.generateKey()
            } catch {
                throw AttestationError.keyNotCreated
            }
        } else {
            throw AttestationError.keyNotCreated
        }
    }
    
    public func verify() async throws {
        // Get keyId and server challenge, send to Apple and get attestation object.
        guard let keyID else { throw AttestationError.noKey }
        
        // Get attestation object from the App Attest service.
        let challenge = try await getChallenge()
        let digest = [ "challenge": challenge ]
        guard let clientData = try? JSONEncoder().encode(digest) else { throw AttestationError.serializingRequestBody }
        let clientDataHash = Data(SHA256.hash(data: clientData))
        
        guard let attestation = try? await service.attestKey(keyID, clientDataHash: clientDataHash) else { throw AttestationError.attestKey }
        
        // Send the attestation object to your server for verification.
        
        // Set up request body.
        let challengeId = try deserializeChallenge(challenge).challengeId
        let payload: [String: String] = [
            "keyId": keyID,
            "challengeId": challengeId,
            "attestation": attestation.base64EncodedString()
        ]
        guard let jsonData = try? JSONEncoder().encode(payload) else { throw AttestationError.serializingRequestBody }
        
        // Set up request.
        var urlRequest = URLRequest(url: URL(string: "https://mobile.build.account.gov.uk/attest")!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        // Send attestation request to server.
        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            let httpResponse = response as? HTTPURLResponse
            verificationSatisfied = httpResponse?.statusCode == 200
        } catch {
            // Handle errors from network call to attest endpoint.
            throw AttestationError.network
        }
    }
    
    public func makeSignedRequest() async throws -> Data {
        // Get keyID and ensure verification has been received.
        guard let keyID else { throw AttestationError.noKey }
        guard let verificationSatisfied, verificationSatisfied else { throw AttestationError.notVerified }
        
        // Send the assertion object as part of your request.
        
        // Get assertion object from the App Attest service.
        let challenge = try await getChallenge()
        let challengeObj = try deserializeChallenge(challenge)
        let digest: [String: String] = [
            "name": "Jamie",
            "challenge": challengeObj.challenge
            // Add additional parts of the request along with the challenge.
        ]
        
        guard let clientData = try? JSONEncoder().encode(digest) else { throw AttestationError.serializingRequestBody }
        let clientDataHash = Data(SHA256.hash(data: clientData))
        
        guard let assertion = try? await service.generateAssertion(keyID, clientDataHash: clientDataHash) else { throw AttestationError.getAssertion }
        
        // Send the assertion and request to your server.
        
        // Set up request body.
        let payload: [String: Any] = [
            "challengeId": challengeObj.challengeId,
            "keyId": keyID,
            "assertion": assertion.base64EncodedString(),
            "clientData": digest
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else { throw AttestationError.serializingRequestBody }
        
        // Set up request.
        var urlRequest = URLRequest(url: URL(string: "https://mobile.build.account.gov.uk/hello-world")!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        // Send request with assertion to server.
        do {
            return try await networkClient.makeRequest(urlRequest)
        } catch {
            // Handle errors from network call to /hello-world endpoint.
            throw AttestationError.network
        }
    }
    
    private func getChallenge() async throws -> Data {
        // Perform network call to /challenge endpoint to get challenge for encoding.
        var challengeUrlRequest = URLRequest(url: URL(string: "https://mobile.build.account.gov.uk/challenge")!)
        challengeUrlRequest.httpMethod = "GET"
        do {
            return try await networkClient.makeRequest(challengeUrlRequest)
        } catch {
            throw AttestationError.getChallenge
        }
    }
    
    private func deserializeChallenge(_ challenge: Data) throws -> Challenge {
        // Deserialize data into Challenge object.
        do {
            return try JSONDecoder().decode(Challenge.self, from: challenge)
        } catch {
            throw AttestationError.serializingChallenge
        }
    }
}
