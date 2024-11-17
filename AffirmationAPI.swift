import Foundation

func fetchAffirmationsFromGemini(completion: @escaping (Result<[String], Error>) -> Void) {
    let region = "northamerica-northeast1"
    let projectID = "gen-lang-client-myproductid" //
    guard let url = URL(string: "https://\(region)-aiplatform.googleapis.com/v1/projects/\(projectID)/locations/\(region)/publishers/google/models/gemini-1.5-flash:generateContent") else {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer MyKey", forHTTPHeaderField: "Authorization") 

    let body: [String: Any] = [
        "prompt": "Generate a positive affirmation.",
        "model": "gemini-1.5-flash",
        "parameters": ["num_results": 1]
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let candidates = json["responses"] as? [String] {
            DispatchQueue.main.async {
                completion(.success(candidates))
            }
        } else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "InvalidData", code: -1, userInfo: nil)))
            }
        }
    }.resume()
}

