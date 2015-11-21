//
//  VimeoResponseSerializer+Upload.swift
//  VimeoUpload
//
//  Created by Alfred Hanssen on 10/21/15.
//  Copyright © 2015 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

extension VimeoResponseSerializer
{
    private static let LocationKey = "Location"
    private static let UploadLinkSecureKey = "upload_link_secure"
    private static let CompleteUriKey = "complete_uri"
    
    func processMeResponse(response: NSURLResponse?, responseObject: AnyObject?, error: NSError?) throws -> VIMUser
    {
        do
        {
            try checkDataResponseForError(response, responseObject: responseObject, error: error)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.Me.rawValue)
        }
        
        do
        {
            return try self.userFromResponseObject(responseObject)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.Me.rawValue)
        }
    }
    
    func processCreateVideoResponse(response: NSURLResponse?, url: NSURL?, error: NSError?) throws -> UploadTicket
    {
        let responseObject: [String: AnyObject]?
        do
        {
            responseObject = try checkDownloadResponseForError(response, url: url, error: error)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.Create.rawValue)
        }
        
        guard let uploadUri = responseObject?[VimeoResponseSerializer.UploadLinkSecureKey] as? String, let activationUri = responseObject?[VimeoResponseSerializer.CompleteUriKey] as? String else
        {
            throw NSError(domain: UploadErrorDomain.Create.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: "Create response did not contain the required values."])
        }
        
        return UploadTicket(uploadUri: uploadUri, activationUri: activationUri)
    }
    
    func processUploadVideoResponse(response: NSURLResponse?, responseObject: AnyObject?, error: NSError?) throws
    {
        do
        {
            try checkDataResponseForError(response, responseObject: responseObject, error: error)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.Upload.rawValue)
        }
    }
    
    func processActivateVideoResponse(response: NSURLResponse?, url: NSURL?, error: NSError?) throws -> String
    {
        do
        {
            try checkDownloadResponseForError(response, url: url, error: error)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.Activate.rawValue)
        }

        guard let HTTPResponse = response as? NSHTTPURLResponse, let location = HTTPResponse.allHeaderFields[VimeoResponseSerializer.LocationKey] as? String else
        {
            throw NSError(domain: UploadErrorDomain.Activate.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: "Activate response did not contain the required value."])
        }
        
        return location
    }

    func processVideoSettingsResponse(response: NSURLResponse?, url: NSURL?, error: NSError?) throws -> VIMVideo
    {
        let responseObject: [String: AnyObject]?
        do
        {
            responseObject = try checkDownloadResponseForError(response, url: url, error: error)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.VideoSettings.rawValue)
        }
        
        do
        {
            return try self.videoFromResponseObject(responseObject)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.VideoSettings.rawValue)
        }
    }
    
    func processVideoSettingsResponse(response: NSURLResponse?, responseObject: AnyObject?, error: NSError?) throws -> VIMVideo
    {
        do
        {
            try checkDataResponseForError(response, responseObject: responseObject, error: error)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.VideoSettings.rawValue)
        }
        
        do
        {
            return try self.videoFromResponseObject(responseObject)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.VideoSettings.rawValue)
        }
    }

    func processDeleteVideoResponse(response: NSURLResponse?, responseObject: AnyObject?, error: NSError?) throws
    {
        do
        {
            try checkDataResponseForError(response, responseObject: responseObject, error: error)
        }
        catch let error as NSError
        {
            throw error.errorByAddingDomain(UploadErrorDomain.Delete.rawValue)
        }
    }

    // MARK: Private API
    
    private func videoFromResponseObject(responseObject: AnyObject?) throws -> VIMVideo
    {
        if let dictionary = responseObject as? [String: AnyObject]
        {
            let mapper = VIMObjectMapper()
            mapper.addMappingClass(VIMVideo.self, forKeypath: "")
            
            if let video = mapper.applyMappingToJSON(dictionary) as? VIMVideo
            {
                return video
            }
        }
        
        throw NSError(domain: VimeoResponseSerializer.ErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Attempt to parse video object from responseObject failed"])
    }

    private func userFromResponseObject(responseObject: AnyObject?) throws -> VIMUser
    {
        if let dictionary = responseObject as? [String: AnyObject]
        {
            let mapper = VIMObjectMapper()
            mapper.addMappingClass(VIMUser.self, forKeypath: "")
            
            if let user = mapper.applyMappingToJSON(dictionary) as? VIMUser
            {
                return user
            }
        }
        
        throw NSError(domain: VimeoResponseSerializer.ErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Attempt to parse user object from responseObject failed"])
    }
}