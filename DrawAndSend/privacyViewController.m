//
//  privacyViewController.m
//  DrawAndSend
//
//  Created by Venkata Maniteja on 2015-10-13.
//  Copyright © 2015 Venkata Maniteja. All rights reserved.
//

#import "privacyViewController.h"

@interface privacyViewController ()

@end

@implementation privacyViewController

@synthesize textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textView.text=@"THE FOLLOWING SETS FORTH ATTRIBUTION NOTICES FOR THIRD PARTY SOFTWARE THAT MAY BE CONSTAINED IN PORTIONS OF THE GIFLITE PRODUCT . \n\nCOLOR PICKER  \n\nThe MIT License (MIT) \n\nCopyright (c) 2015 Fabian Canas\n\nPermission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the \"Software"", to dealin the Softwarwithout restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THEAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THESOFTWARE.";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
