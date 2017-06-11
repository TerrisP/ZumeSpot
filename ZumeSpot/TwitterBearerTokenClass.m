//
//  TwitterBearerTokenClass.m
//  ZumeSpot
//
//  Created by brst on 22/03/17.
//  Copyright © 2017 mrinal khullar. All rights reserved.
//

#import "TwitterBearerTokenClass.h"

@implementation TwitterBearerTokenClass

- (NSString *)bearerToken
{
    if(bearerToken == nil)
    {
        NSString * consumerKey = [@"KOKRbwhZuqnTbr2AUC3ESxl2D" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * consumerSecret = [@"82cPIuPjpLMxrNp4nlXG0XSa3SNorbKSis9ZkQysxMfeVrszJX" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //the combined authentication key is "CONSUMER_KEY:CONSUMER_SECRET" run through base64 encoding.
        //we'll use NSData instead of NSString here so that we can feed it directly to the HTTPRequest later.
        NSString * combinedKey = [[self class] _base64Encode:[[NSString stringWithFormat:@"%@:%@", consumerKey, consumerSecret] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/oauth2/token"]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:[NSString stringWithFormat:@"Basic %@", combinedKey] forHTTPHeaderField:@"Authorization"];
        [urlRequest setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded;charset=UTF-8"] forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:[@"grant_type=client_credentials" dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        bearerToken = [responseJSON valueForKey:@"access_token"];
    }
    return bearerToken;
}
+(NSString *)_base64Encode:(NSData *)data{
    //Point to start of the data and set buffer sizes
    int inLength = [data length];
    int outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
    const char *inputBuffer = [data bytes];
    char *outputBuffer = malloc(outLength);
    outputBuffer[outLength] = 0;
    
    //64 digit code
    static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    //start the count
    int cycle = 0;
    int inpos = 0;
    int outpos = 0;
    char temp;
    
    //Pad the last to bytes, the outbuffer must always be a multiple of 4
    outputBuffer[outLength-1] = '=';
    outputBuffer[outLength-2] = '=';
    
    
    
    while (inpos < inLength){
        switch (cycle) {
            case 0:
                outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
                cycle = 1;
                break;
            case 1:
                temp = (inputBuffer[inpos++]&0x03)<<4;
                outputBuffer[outpos] = Encode[temp];
                cycle = 2;
                break;
            case 2:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
                temp = (inputBuffer[inpos++]&0x0F)<<2;
                outputBuffer[outpos] = Encode[temp];
                cycle = 3;
                break;
            case 3:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
                cycle = 4;
                break;
            case 4:
                outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
                cycle = 0;
                break;
            default:
                cycle = 0;
                break;
        }
    }
    NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
    free(outputBuffer);
    return pictemp;
}
@end
