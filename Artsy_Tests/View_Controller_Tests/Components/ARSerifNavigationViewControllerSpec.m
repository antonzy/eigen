#import "ARSerifNavigationViewController.h"
@import Artsy_UIColors;

SpecBegin(ARSerifNavigationViewController);

__block ARSerifNavigationViewController *subject;
__block UIViewController *host;
__block UIWindow *window;

fdescribe(@"", ^{

    it(@"shows as a form in the center", ^{

        // In order to use FBSnapshots + presentViewController:animated:
        // the view controller has to exist within a key window + view controller
        // structure, or present will not do it's work.

        [ARTestContext useDevice:ARDeviceTypePad :^{
            UIViewController *host = [[UIViewController alloc] init];

            // Setting the frame after ensures that whatever internal
            // method the UIWindow uses to get the app bounds is faked

            UIWindow *window = [[UIWindow alloc] init];
            window.frame = [[UIScreen mainScreen] bounds];

            /// Add a dummy VC, then show the window
            host = [[UIViewController alloc] init];
            window.rootViewController = host;
            [window makeKeyAndVisible];

            host.view.backgroundColor = [UIColor whiteColor];
            UIViewController *insideVC = [[UIViewController alloc] init];
            insideVC.view.backgroundColor = [UIColor greenColor];

            // The presentation _probably_ requires a run-loop tick
            // and so the waitUntil will delay this test to let it run.

            waitUntil(^(DoneCallback done) {
                subject = [[ARSerifNavigationViewController alloc] initWithRootViewController:insideVC];
                [host presentViewController:subject animated:NO completion:^{
                    done();
                }];
            });

            // The host.view is useless here, we're not
            // adding to it, contrary what you'd expect
            expect(window).to.recordSnapshot();

            // It sticks around otherwise.
            window.hidden = YES;
            window = nil;
        }];

    });
});

SpecEnd
