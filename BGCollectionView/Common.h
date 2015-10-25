//
//  Common.h
//  BGCollectionView
//
//  Created by 杨社兵 on 15/10/25.
//  Copyright © 2015年 FAL. All rights reserved.
//

#ifndef Common_h
#define Common_h
//color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//system
#define bScreenWidth [UIScreen mainScreen].bounds.size.width
#define bScreenHeight [UIScreen mainScreen].bounds.size.height

#endif /* Common_h */
