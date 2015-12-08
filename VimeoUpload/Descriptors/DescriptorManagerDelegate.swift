//
//  DescriptorManagerDelegate.swift
//  VimeoUpload
//
//  Created by Hanssen, Alfie on 10/26/15.
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

// Append the "class" keyword to allow weak references to objects that implement this protocol [AH] 10/28/2015

protocol DescriptorManagerDelegate: class
{
    func didLoadDescriptors(count count: Int)
    func didSaveDescriptors(count count: Int)
    func didFailToLoadDescriptor(error error: NSError)
    
    func sessionDidBecomeInvalid(error error: NSError)
    func willHandleEventsForBackgroundSession()
    func didFinishEventsForBackgroundSession()
    
    func downloadTaskDidFinishDownloading(task task: NSURLSessionDownloadTask, descriptor: Descriptor)
    func taskDidComplete(task task: NSURLSessionTask, descriptor: Descriptor, error: NSError?)

    func descriptorAdded(descriptor: Descriptor)
    func descriptorDidSucceed(descriptor: Descriptor)
    func descriptorDidFail(descriptor: Descriptor)
    
    func descriptorForTaskNotFound(task: NSURLSessionTask)
}