#import <Foundation/Foundation.h>
#import "PieceImageView.h"

@interface TouchTestHelper : NSObject

+(void)setTouchTestId:(PieceImageView*)piv withLocationOnBoard:(int)locationOnBoard withPiece:(int)piece;
+(void)updateTouchTestId:(PieceImageView*)piv withLocationOnBoard:(int)locationOnBoard;

@end
