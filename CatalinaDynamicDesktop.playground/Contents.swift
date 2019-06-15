import Foundation
import AppKit
import AVFoundation

let lightImage = NSImage(imageLiteralResourceName: "Mojave Day.jpg")
let darkImage = NSImage(imageLiteralResourceName: "Mojave Night.jpg")
let outputURL = URL(fileURLWithPath: "/Users/harshil/Desktop/output.heic")

guard let imageDestination = CGImageDestinationCreateWithURL(outputURL as CFURL,
                                                             AVFileType.heic as CFString,
                                                             2,
                                                             nil)
else {
    fatalError("Error creating image destination")
}

let imageMetadata = CGImageMetadataCreateMutable()

guard
    let metadata = try? DynamicDesktopMetadata().base64EncodedMetadata() as CFString,
    let tag = CGImageMetadataTagCreate("http://ns.apple.com/namespace/1.0/" as CFString,
                                       "apple_desktop" as CFString,
                                       "apr" as CFString,
                                       .string,
                                       metadata),
    CGImageMetadataSetTagWithPath(imageMetadata, nil, "xmp:apr" as CFString, tag)
else {
    fatalError("Error creating image metadata")
}

guard
    let lightCGImage = lightImage.cgImage,
    let darkCGImage = darkImage.cgImage
else {
    fatalError("Error converting images")
}

CGImageDestinationAddImageAndMetadata(imageDestination, lightCGImage, imageMetadata, nil)
CGImageDestinationAddImage(imageDestination, darkCGImage, nil)

guard CGImageDestinationFinalize(imageDestination) else {
    fatalError("Error finalizing image")
}

let output = NSImage(contentsOf: outputURL)
