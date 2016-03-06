import UIKit
import CoreImage

//: ## Custom Image Filters

let mona = CIImage(image: UIImage(named: "monalisa.jpg")!)!

//: ### General Kernel Pass Through
class GeneralFilter: CIFilter
{
    var inputImage : CIImage?
    
    var kernel = CIKernel(string:
        "kernel vec4 general(sampler image) \n" +
            
        "{ return sample(image, samplerCoord(image)); }"
    )
    
    override var outputImage : CIImage!
    {
        if let inputImage = inputImage, kernel = kernel
        {
            let extent = inputImage.extent
            let arguments = [inputImage]
            
            return kernel.applyWithExtent(extent,
                roiCallback:
                {
                    (index, rect) in
                    return rect
                },
                arguments: arguments)
        }
        return nil
    }
}

let generalFilter = GeneralFilter()
generalFilter.inputImage = mona

let generalResult = generalFilter.outputImage

//: ### Color Kernel Pass Through
class ColorFilter: CIFilter
{
    var inputImage : CIImage?
    
    var colorKernel = CIColorKernel(string:
        "kernel vec4 thresholdFilter(__sample pixel)" +
        "{" +
        "   return pixel;" +
        "}"
    )
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
            colorKernel = colorKernel else
        {
            return nil
        }
        
        let extent = inputImage.extent
        let arguments = [inputImage]
        
        return colorKernel.applyWithExtent(extent,
            arguments: arguments)
    }
}

let colorFilter = ColorFilter()
colorFilter.inputImage = mona

let colorResult = colorFilter.outputImage

//: ### Warp Kernel Pass Through
class WarpFilter: CIFilter
{
    var inputImage : CIImage?
    
    let warpKernel = CIWarpKernel(string:
        "kernel vec2 warp()" +
        "{ return destCoord(); }"
    )
    
    override var outputImage : CIImage!
    {
        if let inputImage = inputImage, kernel = warpKernel
        {
            let extent = inputImage.extent
            
            return kernel.applyWithExtent(extent,
                roiCallback:
                {
                    (index, rect) in
                    return rect
                },
                inputImage: inputImage,
                arguments: [])
        }
        return nil
    }
}

let warpFilter = WarpFilter()
warpFilter.inputImage = mona

let warpResult = warpFilter.outputImage






// ends
