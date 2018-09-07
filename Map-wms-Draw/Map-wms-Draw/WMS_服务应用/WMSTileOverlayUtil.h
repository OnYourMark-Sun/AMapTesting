//
//  WMSTileOverlayUtil.h
//  AirspaceProject
//
//  Created by 徐士友 on 2018/8/23.
//  Copyright © 2018年 AirspaceProject. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface WMSTileOverlayUtil : MATileOverlay

- (id)initWithRootURL:(NSString *)rootRUL;

/**
 * @brief 以tile path生成URL。用于加载tile,此方法默认填充URLTemplate
 * @param path tile path
 * @return 以tile path生成tileOverlay
 */
- (NSURL *)URLForTilePath:(MATileOverlayPath)path;


- (void)loadTileAtPath:(MATileOverlayPath)path result:(void (^)(NSData *tileData, NSError *error))result;
@end
