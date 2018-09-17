///
/// This is the companion code for my conference talk on using server-side Swift
/// via IBM Cloud Functions.
///
/// https://github.com/DevWithTheHair/Conference-Talks/tree/master/Whats-My-Age-Again
///
/// Abstract:
///
/// "What’s My Age Again?"
///
/// Have you ever been at a carnival and had your age guessed in one of those quiz games?
/// The carnival barkers usually struggle to determine my age.
/// What’s my age again?
/// In this talk, we’ll build a microservice in Swift that will use IBM Watson’s Visual Recognition API to figure out my age (and the ages of some celebrities)!
///

import Dispatch
import VisualRecognitionV3

///
/// This function accepts a JSON object that contains an image URL that is to be analyzed for faces.
///
/// Under the covers, this function uses IBM Watson's Visual Recognition API to determine *if* any faces have
/// been detected and the `age` and `gender` of those faces.
///
/// - Parameter args: IBM Cloud Functions actions accept a single parameter, which must be a JSON object.
///                   In this case, we'll look for a JSON object of this form:
///                   {
///                       "image-url": "some_image_url"
///                   }
///
/// - Returns: IBM Cloud Functions must return a JSON object.
///            In this case, we'll return a JSON object of this form with an array element for each detected face:
///            {
///                "faceResults": [
///                    {
///                        "age": {
///                            "confidence": <Double>,
///                            "maxAge": <Int>,
///                            "minAge": <Int>
///                         },
///                        "gender": {
///                            "confidence": <Double>,
///                            "gender": <String>
///                         }
///                    }
///                ]
///            }
///
func main(args: [String: Any]) -> [String: Any] {
    // This is the response that we will ultimately return from this function.
    var response: [String: Any] = [:]
    
    // If our precondition isn't met, return a response letting the caller know
    // that we require a JSON object which contains the image URL.
    guard let imageURL = args["image-url"] as? String else {
        response = ["Error": "Missing Image URL"]
        return response
    }
    
    // We'll use this DispatchSemaphore to wait for the results of the
    // Watson Visual Recognition API call.
    let semaphore = DispatchSemaphore(value: 0)
    
    // This is the closure that gets called if the Watson Visual Recognition API returns an error.
    // For this example, we'll set the response so the caller knows that an error occurred.
    let failure = { (error: Error) in
        response = ["Error": "Generic Failure: \(error)"]
        semaphore.signal()
    }
    
    let apiKey = "your-apikey-here" // This is obtained from your Watson Service credentials.
    let version = "YYYY-MM-DD" // Use the most recent version date compatible with your needs.
    let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
    
    visualRecognition.detectFaces(url: imageURL, failure: failure) { allImages in
        // This will be used as temporary storage for our detected faces.
        var faceResults: [[String: Any]] = []
        
        // For each of the images returned by Watson,
        // loop through each of the faces in a given image and
        // grab the `age` and `gender` attributes that have been identified by Watson.
        for image in allImages.images {
            for face in image.faces {
                // This will be used as temporary storage for an individual face.
                var faceResult: [String: Any] = [:]
                
                if let age = face.age, let minAge = age.min, let maxAge = age.max, let confidenceInAge = age.score  {
                    let ageResult: [String: Any] = [
                        "minAge": minAge,
                        "maxAge": maxAge,
                        "confidence": confidenceInAge
                    ]
                    
                    // We have a valid `age` attribute for our detected face.
                    faceResult["age"] = ageResult
                }
                
                if let gender = face.gender, let confidenceInGender = gender.score {
                    let genderResult: [String: Any] = [
                        "gender": gender.gender,
                        "confidence": confidenceInGender
                    ]
                    
                    // We have a valid `gender` attribute for our detected face.
                    faceResult["gender"] = genderResult
                }
                
                // Add the face to our results.
                faceResults.append(faceResult)
            }
        }
        
        // Add the results to our response.
        response["faceResults"] = faceResults
        
        // Let the execution of the function continue.
        semaphore.signal()
    }
    
    // Wait for the results of the Watson Visual Recognition API.
    semaphore.wait()
    
    // Finally, return the results of the function.
    return response
}
