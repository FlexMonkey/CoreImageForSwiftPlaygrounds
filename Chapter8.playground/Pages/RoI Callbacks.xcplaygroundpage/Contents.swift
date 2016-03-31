//: [Previous](@previous)

import UIKit
import CoreImage

//: ## Horizontal Scale Filter

class StretchFilter: CIFilter
{
    var inputImage: CIImage?
    
    var inputScaleX: CGFloat = 1
    
    let stretchKernel = CIWarpKernel(string:
        "kernel vec2 stretchKernel(float inputScaleX)" +
        "{" +
        "   float y = destCoord().y; " +
        "   float x = (destCoord().x / inputScaleX); " +
        "   return vec2(x, y); " +
        "}"
    )
    
    override var outputImage : CIImage!
    {
        if let inputImage = inputImage,
            kernel = stretchKernel
        {
            let arguments = [ inputScaleX ]
            
            let extent = CGRect(origin: inputImage.extent.origin,
                size: CGSize(
                    width: inputImage.extent.width * inputScaleX,
                    height: inputImage.extent.height))
            
            return kernel.applyWithExtent(extent,
                roiCallback:
                {
                    (index, rect) in
                    
                    let sampleX = rect.origin.x / self.inputScaleX
                    let sampleWidth = rect.width / self.inputScaleX
                    
                    let sampleRect = CGRect(x: sampleX,
                        y: rect.origin.y,
                        width: sampleWidth,
                        height: rect.height)
                    
                    return sampleRect
                },
                inputImage: inputImage,
                arguments: arguments)
        }
        return nil
    }
}

let bouy = CIImage(image: UIImage(named: "bouy.jpg")!)!

let stretchFilter = StretchFilter()

stretchFilter.inputScaleX = 4

stretchFilter.inputImage = bouy

print (stretchFilter.outputImage!.extent)

let stretchedImage = stretchFilter.outputImage!







//: [Next](@next)
