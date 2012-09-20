// AFGDataXMLRequestOperation.m
//
// Copyright (c) 2012 Simon Gätzer simon@graetzer.org
// Copyright (c) 2011 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFGDataXMLRequestOperation.h"

static dispatch_queue_t af_gdataxml_request_operation_processing_queue;
static dispatch_queue_t gdataxml_request_operation_processing_queue() {
    if (af_gdataxml_request_operation_processing_queue == NULL) {
        af_gdataxml_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.gdataxml-request.processing", 0);
    }
    
    return af_gdataxml_request_operation_processing_queue;
}

@interface AFGDataXMLRequestOperation ()
@property (readwrite, nonatomic, retain) GDataXMLDocument *responseXMLDocument;
@property (readwrite, nonatomic, retain) NSError *XMLError;

@end

@implementation AFGDataXMLRequestOperation
@synthesize responseXMLDocument = _responseXMLDocument;
@synthesize XMLError = _XMLError;

+ (AFGDataXMLRequestOperation *)XMLDocumentRequestOperationWithRequest:(NSURLRequest *)urlRequest 
                                                              success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, GDataXMLDocument *XMLDocument))success 
                                                              failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, GDataXMLDocument *XMLDocument))failure
{
    AFGDataXMLRequestOperation *requestOperation = [[[self alloc] initWithRequest:urlRequest] autorelease];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, operation.error, [(AFGDataXMLRequestOperation *)operation responseXMLDocument]);
        }
    }];
    
    return requestOperation;
}

- (void)dealloc {
    [_XMLDocument release];
    [_XMLError release];
    [super dealloc];
}

- (GDataXMLDocument *)responseXMLDocument {
    if (!_responseXMLDocument && [self isFinished] && [self.responseData length] > 0) {
        NSError *error = nil;
        self.responseXMLDocument = [[[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:&error] autorelease];
        self.XMLError = error;
    }
    
    return _responseXMLDocument;
}

- (NSError *)error {
    if (_XMLError) {
        return _XMLError;
    } else {
        return [super error];
    }
}

#pragma mark - AFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"application/xml", @"text/xml", @"text/html", @"application/xhtml+xml", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[[request URL] pathExtension] isEqualToString:@"xml"] || [[[request URL] pathExtension] isEqualToString:@"html"] || [super canProcessRequest:request];
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    self.completionBlock = ^ {
        if ([self isCancelled]) {
            return;
        }
        
        if (self.error) {
            if (failure) {
                dispatch_async(self.failureCallbackQueue ? self.failureCallbackQueue : dispatch_get_main_queue(), ^(void) {
                    failure(self, self.error);
                });
            }
        } else {
            dispatch_async(gdataxml_request_operation_processing_queue(), ^{
                GDataXMLDocument *XMLDocument = self.responseXMLDocument;
                
                if(self.XMLError){
                    if (failure) {
                        dispatch_async( self.failureCallbackQueue ? self.failureCallbackQueue : dispatch_get_main_queue(), ^{
                            failure(self, self.XMLError);
                        });
                    }
                }
                else{
                    if (success) {
                        dispatch_async( self.successCallbackQueue ? self.successCallbackQueue : dispatch_get_main_queue(), ^{
                            success(self, XMLDocument);
                        });
                    }
                }
            });
        }
    };
}

@end
