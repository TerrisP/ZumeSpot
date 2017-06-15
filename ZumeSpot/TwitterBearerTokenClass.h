//
//  TwitterBearerTokenClass.h
//  ZumeSpot
//
//  Created by Terris Phillips on 6/4/17.
//  Copyright © 2017 Terris Phillips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterBearerTokenClass : NSObject{
    NSMutableString *bearerToken;
   
}


- (NSString *)bearerToken;

@end
