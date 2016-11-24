//
//  TASpringFlowLayout.h
//  HeroCam App
//
//  Created by Diomidis Papas on 05/10/2016.
//  Copyright © 2016 Diomidis Papas. All rights reserved.
//

@import UIKit;

/// The default resistance factor that determines the bounce of the collection. Default is 900.0f.
#define kScrollResistanceFactorDefault 900.0f;

/// A UICollectionViewFlowLayout subclass that, when implemented, creates a dynamic / bouncing scroll effect for UICollectionViews.
@interface TASpringFlowLayout : UICollectionViewFlowLayout

/// The scrolling resistance factor determines how much bounce / resistance the collection has. A higher number is less bouncy, a lower number is more bouncy. The default is 900.0f.
@property (nonatomic, assign) CGFloat scrollResistanceFactor;

/// The dynamic animator used to animate the collection's bounce
@property (nonatomic, strong, readonly) UIDynamicAnimator *dynamicAnimator;

@end
