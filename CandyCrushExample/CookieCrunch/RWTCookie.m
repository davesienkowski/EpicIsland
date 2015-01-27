//
//  RWTCookie.m
//  CookieCrunch
//
//  Created by Matthijs on 25-02-14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "RWTCookie.h"

@implementation RWTCookie

- (NSString *)spriteName {
  static NSString * const spriteNames[] = {
    @"Croissant",
    @"Cupcake",
    @"Danish",
    @"Donut",
    @"Macaroon",
    @"SugarCookie",
  };

  return spriteNames[self.cookieType - 1];
}

- (NSString *)highlightedSpriteName {
  static NSString * const highlightedSpriteNames[] = {
    @"Croissant-Highlighted",
    @"Cupcake-Highlighted",
    @"Danish-Highlighted",
    @"Donut-Highlighted",
    @"Macaroon-Highlighted",
    @"SugarCookie-Highlighted",
  };

  return highlightedSpriteNames[self.cookieType - 1];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"type:%ld square:(%ld,%ld)", (long)self.cookieType, (long)self.column, (long)self.row];
}

@end
