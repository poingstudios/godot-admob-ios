// MIT License
//
// Copyright (c) 2023 Poing Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "JavaObjectToGodotDictionary.h"

@implementation JavaObjectToGodotDictionary

+ (Dictionary)convertGADInitializationStatusToDictionary:(GADInitializationStatus *)status {
    Dictionary dictionary;
    
    NSDictionary *adapterStatuses = [status adapterStatusesByClassName];
    for (NSString *adapter in adapterStatuses) {
        GADAdapterStatus *adapterStatus = adapterStatuses[adapter];
        Dictionary adapterDictionary = [JavaObjectToGodotDictionary convertGADAdapterStatusToDictionary:adapterStatus];
        dictionary[[adapter UTF8String]] = adapterDictionary;
    }
    
    return dictionary;
}

+ (Dictionary)convertGADAdapterStatusToDictionary:(GADAdapterStatus *)adapterStatus {
    Dictionary dictionary;
    
    NSString *description = adapterStatus.description;
    NSTimeInterval latency = adapterStatus.latency;
    GADAdapterInitializationState state = adapterStatus.state;

    dictionary["description"] = [description UTF8String];
    dictionary["latency"] = latency;
    dictionary["initializationState"] = @(state);
    
    return dictionary;
}

@end