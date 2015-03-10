//
//  ViewController.m
//  ImbdMovies
//
//  Created by Maximiliano Casal on 3/10/15.
//  Copyright (c) 2015 Maximiliano Casal. All rights reserved.
//

#import "LoginViewController.h"
#import "MovieUser.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onTapGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
- (IBAction)onLoginPressed:(id)sender {
    NSString *name = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![self userExist:name]) {
        [self addUser:name password:password];
    }
}

-(BOOL) userExist: (NSString *)userName{

    return NO;
}

-(void) addUser: (NSString *)userName password:(NSString*) password{
    MovieUser *user = [MovieUser new];
    user.name = userName;
    user.password = password;
    
    

}

@end
