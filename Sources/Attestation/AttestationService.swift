import CryptoKit
import DeviceCheck
import Networking

enum AttestationError: Error {
    case attestKey
    case getAssertion
    case getChallenge
    case noKey
    case notVerified
    case serializingRequestBody
    case serializingChallenge
}

@available(iOS 14.0, *)
final class AttestationService {
    private let service = DCAppAttestService.shared
    private let networkClient = NetworkClient()
    private var keyID: String?
    private var verificationSatisfied: Bool?
    
    public func generate() {
        // Ensure device supports app attest
        if service.isSupported {
            // Perform key generation.
            service.generateKey { keyId, error in
                guard error == nil else { print("error generating key"); return }
                
                // Cache keyId for subsequent operations.
                
                self.keyID = keyId
            }
        }
    }
    
    public func verify() async throws {
        // Get keyId and server challenge, send to Apple and get attestation object
        guard let keyID else { throw AttestationError.noKey }
        let challenge = try await getChallenge()
        guard let attestation = try? await service.attestKey(keyID, clientDataHash: challenge) else { throw AttestationError.attestKey }
        
        // Send the attestation object to your server for verification.
        
        // Set up request body
        let challengeId = try serializeChallenge(challenge).challengeId
        let attestRequest: [String: Any] = [ "challengeId": challengeId, "keyId": keyID, "attestation": attestation ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: attestRequest) else { throw AttestationError.serializingRequestBody }
        
        // Set up request
        var urlRequest = URLRequest(url: URL(string: "https://mobile.build.account.gov.uk/attest")!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        // Send attestation request to server
        let task = URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            guard error == nil else {
                // request sending failed, try again later
                print("Failed validity checks with error: \(error!)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            self.verificationSatisfied = httpResponse.statusCode == 200
        }
        task.resume()
    }
    
    public func makeSignedRequest() async throws {
        // Get keyId and ensure verification has been received
        guard let keyID else { throw AttestationError.noKey }
        guard let verificationSatisfied, verificationSatisfied else { throw AttestationError.notVerified }
        
        // Send the assertion object as part of your request.
        
        // Set up request body
        let challenge = try await getChallenge()
        let request = [ "challenge": challenge /* Add additional parts of the request along with the challenge */ ]
        guard let clientData = try? JSONEncoder().encode(request) else { throw AttestationError.serializingRequestBody }
        let clientDataHash = Data(SHA256.hash(data: clientData))
        
        guard let assertion = try? await service.generateAssertion(keyID, clientDataHash: clientDataHash) else { throw AttestationError.getAssertion }
                
        // Send the assertion and request to your server.
        
        // Set up request body
        let assertRequest: [String: Any] = ["assertion": assertion]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: assertRequest) else { throw AttestationError.serializingRequestBody }
        
        // Set up request
        var urlRequest = URLRequest(url: URL(string: "https://mobile.build.account.gov.uk/hello-world")!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        // Send request with assertion to server
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                // request sending failed, try again later
                print("Failed request with error: \(error!)")
                return
            }
            
            // Return data if successful
        }
        task.resume()
    }
    
    private func getChallenge() async throws -> Data {
        // perform network call to /challenge endpoint to get challenge for encoding
        let challengeUrlRequest = URLRequest(url: URL(string: "https://mobile.build.account.gov.uk/challenge")!)
        do {
            return try await networkClient.makeRequest(challengeUrlRequest)
        } catch {
            throw AttestationError.getChallenge
        }
    }
    
    private func serializeChallenge(_ challenge: Data) throws -> Challenge {
        do {
            return try JSONDecoder().decode(Challenge.self, from: challenge)
        } catch {
            throw AttestationError.serializingChallenge
        }
    }
}
