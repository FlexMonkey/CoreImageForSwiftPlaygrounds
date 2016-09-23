//: # Core Image for Swift

//: ##  Querying Core Image for Filters

import UIKit
import CoreImage

//: ### Filter Categories

kCICategoryHalftoneEffect

CIFilter.localizedName(forCategory: kCICategoryHalftoneEffect)

//: ### Querying for Filters

CIFilter.filterNames(inCategory: kCICategoryHalftoneEffect)

CIFilter.filterNames(inCategories: nil)

CIFilter.filterNames(inCategories: [kCICategoryVideo,
    kCICategoryStillImage])

CIFilter.filterNames(inCategories: [kCICategoryBlur,
    kCICategorySharpen])

//: ### Using the Filter Name

CIFilter.localizedName(forFilterName: "CICMYKHalftone")

CIFilter.localizedDescription(forFilterName: "CICMYKHalftone")

CIFilter(name: "xyz")

CIFilter(name: "CICMYKHalftone")

//: ### Interrogating the Filter

let filter = CIFilter(name: "CICMYKHalftone")!
let inputKeys = filter.inputKeys

filter.attributes.filter({ !inputKeys.contains($0.0) })

filter.attributes.filter({ inputKeys.contains($0.0) })

if let
    attribute = filter
        .attributes["inputGCR"] as? [String: AnyObject],
    let minimum = attribute[kCIAttributeSliderMin] as? Float,
    let maximum = attribute[kCIAttributeSliderMax] as? Float,
    let defaultValue = attribute[kCIAttributeDefault] as? Float ,
    (attribute[kCIAttributeClass] as? String) == "NSNumber"
{
    let slider = UISlider()
    
    slider.minimumValue = minimum
    slider.maximumValue = maximum
    slider.value = defaultValue
}

Set<String>(CIFilter.filterNames(inCategory: nil).flatMap {
    CIFilter(name: $0)!
        .attributes[kCIAttributeFilterCategories] as! [String]
    }).sorted()


//: [Next](@next)




