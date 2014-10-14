//
//  BCAlerts.m
//  BioCaching
//
//  Created by Andy Jeffrey on 16/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCAlerts.h"

@interface BCAlerts ()
@property (nonatomic, copy) void (^okBlock)(void);
@property (nonatomic, copy) void (^cancelBlock)(void);
@end

@implementation BCAlerts

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static BCAlerts *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BCAlerts sharedInstance]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        [self resetAlertBlocks];
    }
    return self;
}

- (void)resetAlertBlocks
{
    self.okBlock = nil;
    self.cancelBlock = nil;
}


+ (void)displayDefaultInfoAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title, nil)
                                                 message:NSLocalizedString(message, nil)
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                       otherButtonTitles:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [av show];
    });
}

+ (void)displayOKAlertWithCallback:(NSString *)title message:(NSString *)message mainButtonTitle:(NSString *)mainButtonTitle okBlock:(void (^)(void))okBlock
{
    [[self sharedInstance] setOkBlock:okBlock];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title, nil)
                                                 message:NSLocalizedString(message, nil)
                                                delegate:[self sharedInstance]
                                       cancelButtonTitle:NSLocalizedString(mainButtonTitle, nil)
                                       otherButtonTitles:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [av show];
    });
    
}

+ (void)displayOKorCancelAlert:(NSString *)title message:(NSString *)message okBlock:(void (^)(void))okBlock cancelBlock:(void (^)(void))cancelBlock
{
    [[self sharedInstance] setOkBlock:okBlock];
    [[self sharedInstance] setCancelBlock:cancelBlock];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title, nil)
                                                 message:NSLocalizedString(message, nil)
                                                delegate:[self sharedInstance]
                                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                       otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [av show];
    });
}

+ (void)displayOKorCancelAlert:(NSString *)title message:(NSString *)message
                 okButtonTitle:(NSString *)okButtonTitle okBlock:(void (^)(void))okBlock
             cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(void (^)(void))cancelBlock
{
    [[self sharedInstance] setOkBlock:okBlock];
    [[self sharedInstance] setCancelBlock:cancelBlock];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title, nil)
                                                 message:NSLocalizedString(message, nil)
                                                delegate:[self sharedInstance]
                                       cancelButtonTitle:NSLocalizedString(cancelButtonTitle, nil)
                                       otherButtonTitles:NSLocalizedString(okButtonTitle, nil), nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [av show];
    });
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.cancelBlock();
    } else if (buttonIndex == 1) {
        self.okBlock();
    }
    [self resetAlertBlocks];
}


+ (void)displayDropDownNotification:(NSString *)title subtitle:(NSString *)subtitle messageType:(TSMessageNotificationType)messageType duration:(double)duration
{
    // Run NotificationMessage on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [TSMessage showNotificationInViewController:TSMessage.defaultViewController title:title subtitle:subtitle type:messageType duration:duration];
    });
}

+ (void)displayDefaultSuccessNotification:(NSString *)title subtitle:(NSString *)subtitle
{
#ifdef TESTING
    [self displayDropDownNotification:title subtitle:subtitle messageType:TSMessageNotificationTypeSuccess duration:1];
#else
    [self displayDropDownNotification:title subtitle:subtitle messageType:TSMessageNotificationTypeSuccess duration:2];
#endif
}

+ (void)displayDefaultFailureNotification:(NSString *)title subtitle:(NSString *)subtitle
{
#ifdef TESTING
    [self displayDropDownNotification:title subtitle:subtitle messageType:TSMessageNotificationTypeError duration:1];
#else
    [self displayDropDownNotification:title subtitle:subtitle messageType:TSMessageNotificationTypeError duration:2];
#endif
}

+ (void)displayDefaultInfoNotification:(NSString *)title subtitle:(NSString *)subtitle
{
#ifdef TESTING
    [self displayDropDownNotification:title subtitle:subtitle messageType:TSMessageNotificationTypeMessage duration:1];
#else
    [self displayDropDownNotification:title subtitle:subtitle messageType:TSMessageNotificationTypeMessage duration:2];
#endif
}

@end
