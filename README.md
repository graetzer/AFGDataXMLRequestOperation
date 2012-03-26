# AFGDataXMLRequestOperation

AFGDataXMLRequestOperation is an extension for [AFNetworking](http://github.com/AFNetworking/AFNetworking/) that provides an interface to parse XML using [GDataXML](https://github.com/graetzer/GDataXML-HTML)
Only the original parts of GDataXMl are used not the HTML additions. 
This is still in early stages of development, so proceed with caution when using this in a production application. Any bug reports, feature requests, or general feedback at this point would be greatly appreciated.

## Example Usage

``` objective-c
AFGDataXMLRequestOperation *operation = [AFGDataXMLRequestOperation XMLDocumentRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://legalindexes.indoff.com/sitemap.xml"]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, GDataXMLDocument *XMLDocument) {
      NSLog(@"XMLDocument: %@", XMLDocument);
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, GDataXMLDocument *XMLDocument) {
      NSLog(@"Failure!");
}];
// Just start the operation on a background thread
[operation start];
// Or put it in a queue, if you want to handle many operations in a row
NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
[queue addOperation:operation];
```

## ARC
### Neither AFNetworking or GDataXML support ARC at the moment
### If your code is using Automatic Reference Counting (ARC) do the following:

1. Select Build Phases tab.

2. Expand Compile Sources.

3. Select each file of AFNetworking and GDataXML then press Enter.

4. On the small input box that pops-out, enter -fno-objc-arc.

# Contact

Simon Grätzer

- http://github.com/graetzer
- http://twitter.com/ciron
- simon@graetzer.org

# Credits
This Code is basically a slight modification of Mattt Thompson's AFKissXMLRequestOperation (https://github.com/AFNetworking/AFKissXMLRequestOperation)

# License

AFGDataXMLRequestOperation is available under the MIT license. See the LICENSE file for more info.
