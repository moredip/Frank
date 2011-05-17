
@interface UIDescendants : NSObject {

}

-(NSArray *)collect:(NSArray *)views;
-(void)collectDescendantsOnView:(UIView *)view inToArray:(NSMutableArray *)array;
+(id)withTraversal;

@end
