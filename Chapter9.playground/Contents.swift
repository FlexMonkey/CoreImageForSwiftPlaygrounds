//: ## Luminance Based Masked Variable Blur

import UIKit
import CoreImage
//: ### MaskedVariableBlur filter
class MaskedVariableBlur: CIFilter
{
    var inputImage: CIImage?
    var inputBlurImage: CIImage?
    var inputBlurRadius: CGFloat = 5
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Metal Pixellate" as AnyObject,
            
            "inputImage": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIImage",
                kCIAttributeDisplayName: "Image",
                kCIAttributeType: kCIAttributeTypeImage],
            
            "inputBlurImage": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIImage",
                kCIAttributeDisplayName: "Image",
                kCIAttributeType: kCIAttributeTypeImage],
            
            "inputBlurRadius": [kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 5,
                kCIAttributeDisplayName: "Pixel Height",
                kCIAttributeMin: 0,
                kCIAttributeSliderMin: 0,
                kCIAttributeSliderMax: 100,
                kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    let maskedVariableBlur = CIKernel(string:
        "kernel vec4 lumaVariableBlur(sampler image, sampler blurImage, float blurRadius) " +
            "{ " +
            "   vec2 d = destCoord(); " +
            "    vec3 blurPixel = sample(blurImage, samplerCoord(blurImage)).rgb; " +
            "    float blurAmount = dot(blurPixel, vec3(0.2126, 0.7152, 0.0722)); " +
            "    float n = 0.0; " +
            "    int radius = int(blurAmount * blurRadius); " +
            "    vec3 accumulator = vec3(0.0, 0.0, 0.0); " +
            "    for (int x = -radius; x <= radius; x++) " +
            "    { " +
            "        for (int y = -radius; y <= radius; y++) " +
            "        { " +
            "            vec2 workingSpaceCoordinate = d + vec2(x,y); " +
            "            vec2 imageSpaceCoordinate = samplerTransform(image, workingSpaceCoordinate); " +
            "            vec3 color = sample(image, imageSpaceCoordinate).rgb; " +
            "            accumulator += color; " +
            "            n += 1.0; " +
            "        } " +
            "    } " +
            "    accumulator /= n; " +
            "    return vec4(accumulator, 1.0); " +
        "} "
    )
    
    override var outputImage: CIImage!
    {
        guard let
            inputImage = inputImage,
            let inputBlurImage = inputBlurImage else
        {
            return nil
        }
        
        let extent = inputImage.extent

        let blur = maskedVariableBlur?.apply(
            withExtent: inputImage.extent,
            roiCallback:
            {
                (index, rect) in
                return rect
            },
            arguments: [inputImage, inputBlurImage, inputBlurRadius])
        
        return blur!.cropping(to: extent)
    }
}
//: ### Filter vendor
class FilterVendor: NSObject, CIFilterConstructor
{
    
    func filter(withName: String) -> CIFilter?
    {
        switch withName
        {
        case "MaskedVariableBlur":
            return MaskedVariableBlur()

        default:
            return nil
        }
    }
}
//: ### Register filter

CIFilter.registerName("MaskedVariableBlur",
                            constructor: FilterVendor(),
                            classAttributes: [kCIAttributeFilterName: "MaskedVariableBlur"])
//: ### Source Image
let monaLisa = CIImage(image: UIImage(named: "monalisa.jpg")!)!
//: ### Radial gradient
let gradientImage = CIFilter(
    name: "CIRadialGradient",
    withInputParameters: [
        kCIInputCenterKey: CIVector(x: 310, y: 390),
        "inputRadius0": 100,
        "inputRadius1": 300,
        "inputColor0": CIColor(red: 0, green: 0, blue: 0),
        "inputColor1": CIColor(red: 1, green: 1, blue: 1)
    ])?
    .outputImage?
    .cropping(to: monaLisa.extent)
//: ### Final output
let final = monaLisa.applyingFilter("MaskedVariableBlur", withInputParameters: ["inputBlurRadius": 10, "inputBlurImage": gradientImage!])

