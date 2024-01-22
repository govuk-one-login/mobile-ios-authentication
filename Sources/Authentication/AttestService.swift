import CryptoKit
import DeviceCheck

@available(iOS 14.0, *)
class AttestService {
    let service = DCAppAttestService.shared
    var keyID: String?
    var verificationSatisfied: Bool?
    
    func generate() {
        if service.isSupported {
            // Perform key generation and attestation.
            service.generateKey { keyId, error in
                guard error == nil else { print("error generating key"); return }
                
                // Cache keyId for subsequent operations.
                
                self.keyID = keyId
            }
        }
    }
    
    func certify() throws {
        // perform network call to /challenge endpoint to get challenge for encoding
        let challenge = try JSONEncoder().encode([String: String]())
        let hash = Data(SHA256.hash(data: challenge))
        
        service.attestKey(keyID!, clientDataHash: hash) { attestation, error in
            guard error == nil else { print("error attesting key"); return }
            
            // Send the attestation object to your server for verification.
            
            // Set up request
            var urlRequest = URLRequest(url: URL(string: "https://mobile.build.account.gov.uk/attest")!)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Set up request body
            let encodedChallenge = challenge.base64EncodedString() /* Is this needed again? */
            let encodedAttestation = attestation!.base64EncodedString()
            let attestRequest: [String: Any] = ["challenge": encodedChallenge, "attestation": encodedAttestation]
            
            let jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: attestRequest, options: [])
                urlRequest.httpBody = jsonData
            } catch {
                print("error serializing data: \(error)")
                return
            }
            
            // send attestation request to server
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
    }
    
    func makeSignedRequest() {
        guard let verificationSatisfied else { return }
        
        if verificationSatisfied {
            let challenge = String() /* A string from your server */
            let request = [ "action": "getGameLevel",
                            "levelId": "1234",
                            "challenge": challenge ]
            guard let clientData = try? JSONEncoder().encode(request) else { return }
            let clientDataHash = Data(SHA256.hash(data: clientData))
            
            service.generateAssertion(keyID!, clientDataHash: clientDataHash) { assertion, error in
                guard error == nil else { print("error generating assertion"); return }

                // Send the assertion and request to your server.
                
                // Set up request
                var urlRequest = URLRequest(url: URL(string: "https://mobile.build.account.gov.uk/hello-world")!)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // Set up request body
                let encodedAssertion = assertion!.base64EncodedString()
                let assertRequest: [String: Any] = ["assertion": encodedAssertion]
                
                let jsonData: Data
                do {
                    jsonData = try JSONSerialization.data(withJSONObject: assertRequest, options: [])
                    urlRequest.httpBody = jsonData
                } catch {
                    print("error serializing data: \(error)")
                    return
                }
                
                // send request with assertion to server
                let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    guard error == nil else {
                        // request sending failed, try again later
                        print("Failed request with error: \(error!)")
                        return
                    }
                }
                task.resume()
            }
        }
    }
}
