///
/// This is the companion code for my conference talk on using server-side Swift
/// via IBM Cloud Functions hosted on Bluemix.
///
/// Abstract:
///
/// "Elementary (Celebrity Recognition), My Dear Watson"
///
/// Do you ever have trouble matching a name to a face?
/// Or wondered if someone was considered a bonafide ‘celebrity’?
/// Well, wonder no further!
/// In this talk, we’ll build a microservice in Swift that will use IBM Watson’s Visual Recognition API to figure out *who* is a celebrity!
///

import Dispatch
import VisualRecognitionV3

///
/// This function accepts a JSON object that contains an image URL that is to be analyzed for celebrity faces.
///
/// Under the covers, this function uses IBM Watson's Visual Recognition API to determine *if* any celebrities have
/// been identified and *who* those celebrities are.
///
/// - Parameter args: IBM Cloud Functions actions accept a single parameter, which must be a JSON object.
///                   In this case, we'll look for a JSON object of the form:
///                   {
///                       "image-url": "some_image_url"
///                   }
///
/// - Returns: IBM Cloud Functions must return a JSON object.
///            In this case, we'll return a JSON object of the form:
///            {
///                "results": [
///                    {
///                        "isCelebrity": true,
///                        "name": "celebrity-name"
///                    }
///                ]
///            }
///
func main(args: [String:Any]) -> [String:Any] {
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
    
    // This is the closure that the Watson Visual Recognition API will used in the case of a failure.
    // For this example, we'll set the response so the caller knows that an error occurred.
    let failure = { (error: Error) in
        response = ["Error": "Generic Failure"]
        semaphore.signal()
    }
    
    let apiKey = "your-apikey-here" // This is obtained from your Watson Service credentials.
    let version = "YYYY-MM-DD" // Use today's date for the most recent version.
    let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
    
    visualRecognition.detectFaces(inImage: imageURL, failure: failure) { allImages in
        // This will be used as temporary storage for our detected celebrities.
        var celebrityResults: [[String: Any]] = []
        
        // For each of the images returned by Watson,
        // loop through each of the faces in a given image and
        // determine if the face has been identified as a celebrity by Watson.
        allImages.images.forEach { image in
            image.faces.forEach { face in
                if let identity = face.identity {
                    // This is a celebrity!
                    let celebrity: [String: Any] = [
                        "isCelebrity": true,
                        "name": identity.name
                    ]
                    // Add the celebrity to our results.
                    celebrityResults.append(celebrity)
                } else {
                    // This is not a celebrity.
                    let anonymous: [String: Any] = [
                        "isCelebrity": false,
                        "name": "Unknown"
                    ]
                    // Add the unknown person to our results.
                    celebrityResults.append(anonymous)
                }
            }
        }
        
        // Add the results to our response.
        response["celebrityResults"] = celebrityResults
        
        // Let the execution of the function continue.
        semaphore.signal()
    }
    
    // Wait for the results of the Watson Visual Recognition API.
    semaphore.wait()
    
    // Finally, return the results of the function.
    return response
}
