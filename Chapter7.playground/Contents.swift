//: ## Composite Image Color Kernels

import UIKit
import CoreImage
import PlaygroundSupport

let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 640, height: 640))

imageView.contentMode = .center

let ciContext = CIContext()

func imageFromCIImage(source: CIImage) -> UIImage
{
    let cgImage = ciContext.createCGImage(source,
                                          from: source.extent)
    
    return UIImage(cgImage: cgImage!)
}

PlaygroundPage.current.liveView = imageView

//: ### RedGreenFilter

class RedGreenFilter: CIFilter
{
    var inputImage: CIImage?
    var inputBackgroundImage: CIImage?
    
    var extent: CGRect?
    
    var kernel = CIColorKernel(string:
        "kernel vec4 thresholdFilter(__sample image)" +
        "{" +
        "   return vec4(image.r, image.g * 0.5, 0.0, image.a);" +
        "}"
    )
    
override var outputImage: CIImage!
{
    guard let inputImage = inputImage,
        let kernel = kernel else
    {
        return nil
    }
    
    let extent = self.extent ?? inputImage.extent
    
    let arguments = [inputImage]
    
    return kernel.apply(withExtent: extent,
        arguments: arguments)
}
}

//: ### BlueGreenFilter

class BlueGreenFilter: CIFilter
{
    var inputImage: CIImage?
    var inputBackgroundImage: CIImage?
    
    var extent: CGRect?
    
    var kernel = CIColorKernel(string:
        "kernel vec4 thresholdFilter(__sample image)" +
        "{" +
        "   return vec4(0.0, image.g * 0.5, image.b, image.a);" +
        "}"
    )
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
            let kernel = kernel else
        {
            return nil
        }
        
        let extent = self.extent ?? inputImage.extent
        
        let arguments = [inputImage]
        
        return kernel.apply(withExtent: extent,
            arguments: arguments)
    }
}

// ---

let sunflower = CIImage(image: UIImage(named: "sunflower.jpg")!)!

//: ### Landscape sunflower demonstration
let blueGreenFilter = BlueGreenFilter()
blueGreenFilter.inputImage = sunflower
blueGreenFilter.extent = sunflower.extent.insetBy(dx: 0, dy: 200)
let blueGreenOutput = blueGreenFilter.outputImage

//imageView.image = imageFromCIImage(blueGreenOutput)

//: ### Portrait sunflower demonstration
let redGreenFilter = RedGreenFilter()
redGreenFilter.inputImage = sunflower
redGreenFilter.extent = sunflower.extent.insetBy(dx: 200, dy: 0)
let redGreenOutput = redGreenFilter.outputImage

//imageView.image = imageFromCIImage(redGreenOutput)

let additionImageOne = blueGreenOutput?
    .applyingFilter("CIAdditionCompositing",
        withInputParameters: [
            kCIInputBackgroundImageKey: redGreenOutput])

// imageView.image = imageFromCIImage(additionImageOne)

let blueGreenRender = CIImage(image: imageFromCIImage(source: blueGreenOutput!))!
    .applying(CGAffineTransform(translationX: 0, y: 220))

let redGreenRender = CIImage(image: imageFromCIImage(source: redGreenOutput!))!
    .applying(CGAffineTransform(translationX: 220, y: 0))

let additionImageTwo = blueGreenRender
    .applyingFilter("CIAdditionCompositing",
        withInputParameters: [
            kCIInputBackgroundImageKey: redGreenRender])

// imageView.image = imageFromCIImage(additionImageTwo)

//: ## Composite Image Color Kernels (Colored boxes)

class AddComposite: CIFilter
{
    var inputImage: CIImage?
    var inputBackgroundImage: CIImage?

    var extentFunction: (CGRect, CGRect) -> CGRect = { (a: CGRect, b: CGRect) in return CGRect.zero }
    
    var kernel = CIColorKernel(string:
        "kernel vec4 thresholdFilter(__sample image, __sample backgroundImage)" +
        "{" +
        "   return image + backgroundImage;" +
        "}"
    )
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
            let inputBackgroundImage = inputBackgroundImage,
            let addKernel = kernel else
        {
            return nil
        }
        
        let extent = extentFunction(inputImage.extent,
            inputBackgroundImage.extent)
        
        let arguments = [inputImage, inputBackgroundImage]
        
        return addKernel.apply(withExtent: extent,
            arguments: arguments)
    }
}

let red = CIColor(red: 1, green: 0, blue: 0)
let blue = CIColor(red: 0, green: 0, blue: 1)

let redPortrait = CIImage(color: red)
    .cropping(to: CGRect(
        origin: CGPoint(x: 220, y: 20),
        size: CGSize(width: 200, height: 600)))

let blueLandscape = CIImage(color: blue)
    .cropping(to: CGRect(
        origin: CGPoint(x: 20, y: 220),
        size: CGSize(width: 600, height: 200)))

let regularComposite = redPortrait
    .applyingFilter("CIAdditionCompositing",
        withInputParameters: [kCIInputBackgroundImageKey: blueLandscape])




let addFilter = AddComposite()
addFilter.inputImage = redPortrait
addFilter.inputBackgroundImage = blueLandscape

//: ### `portrait` demonstration
addFilter.extentFunction = { (fore, back) in return fore }
let portrait = addFilter.outputImage
// imageView.image = imageFromCIImage(portrait)

//: ### `landscape` demonstration
addFilter.extentFunction = { (fore, back) in return back }
let landscape = addFilter.outputImage
// imageView.image = imageFromCIImage(landscape)

//: ### `union` demonstration
addFilter.extentFunction = { (fore, back) in return fore.union(back) }
let union = addFilter.outputImage
// imageView.image = imageFromCIImage(union)

//: ### `intersect` demonstration
addFilter.extentFunction = { (fore, back) in fore.intersection(back) }
let intersect = addFilter.outputImage
imageView.image = imageFromCIImage(source: intersect!)



// ends...
