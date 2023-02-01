//
//  APIConstants.swift
//  KittyFacts
//
//  Created by Swapnil Ratnaparkhi on 1/31/23.
//

import Foundation

enum APIError: Error {
    case errorURL
    case errorResponse
    case errorParsing
}

enum Constants: String {
    case kittyImageURL = "http://placekitten.com/"
    case kittyDescriptionURL = "https://meowfacts.herokuapp.com"
}
