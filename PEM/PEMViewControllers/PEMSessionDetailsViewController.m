//
//  PEMSessionDetailsViewController.m
//  PEM
//
//  Created by Vladimir Hartmann on 06/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMSessionDetailsViewController.h"

@implementation PEMSessionDetailsViewController

@synthesize sessionNameString;
@synthesize dateString;
@synthesize activityString;
@synthesize distanceTravelledString;
@synthesize totalTimeString;
@synthesize highestSpeedString;
@synthesize averageGradeString;
@synthesize vo2String;
@synthesize caloriesString;
@synthesize co2EmissionsString;
@synthesize caloriesBigString;
@synthesize co2EmissionsBigString;

@synthesize sessionName = _sessionName;
@synthesize date = _date;
@synthesize activity = _activity;
@synthesize distanceTravelled = _distanceTravelled;
@synthesize totalTime = _totalTime;
@synthesize highestSpeed = _highestSpeed;
@synthesize averageGrade = _averageGrade;
@synthesize vo2 = _vo2;
@synthesize calories = _calories;
@synthesize co2Emissions = _co2Emissions;
@synthesize footerInfoTop = _footerInfoTop;
@synthesize footerInfoBody = _footerInfoBody;
@synthesize footerInfoBottom = _footerInfoBottom;
@synthesize locationDataObject;
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void)showPersonalWellbeingFooter {
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart.png"]];
    [imageView setFrame:CGRectMake(70,335,60,60)]; //Adjust X,Y,W,H as needed
    [[self view] addSubview: imageView];
    
    _footerInfoTop.text = @"You've burned";
    _footerInfoBody.text = caloriesBigString;
    _footerInfoBottom.text = @"Calories";
}

-(void)showPlanetaryWellbeingFooter {
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"globe.png"]];
    [imageView setFrame:CGRectMake(70,335,60,60)]; //Adjust X,Y,W,H as needed
    [[self view] addSubview: imageView];
    
    _footerInfoTop.text = @"Carbon footprint";
    _footerInfoBody.text = co2EmissionsBigString;
    _footerInfoBottom.text = @"kgCO2";
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
        
    _sessionName.text = sessionNameString;
    _date.text = dateString;
    _activity.text = activityString;
    _distanceTravelled.text = distanceTravelledString;
    _totalTime.text = totalTimeString;
    _highestSpeed.text = highestSpeedString;
    _averageGrade.text = averageGradeString;
    _vo2.text = vo2String;
    NSString *calories = [[NSString alloc] initWithFormat:@"%@%@",caloriesString, @" kcal"];
    _calories.text = calories;
    NSString *co2Emissions = [[NSString alloc] initWithFormat:@"%@%@",co2EmissionsString, @" kgCO2"];
    _co2Emissions.text = co2Emissions;
    
    // show personal wellbeing icon
    if ([activityString isEqualToString:@"Walk"] || [activityString isEqualToString:@"Run"]) {
        [self showPersonalWellbeingInfoButton];
        [self showPersonalWellbeingFooter];
    }
    
    // show planetary wellbeing icon
    if ([activityString isEqualToString:@"Car"] || [activityString isEqualToString:@"Bus"] ||
        [activityString isEqualToString:@"Train"]) {
        [self showPlanetaryWellbeingInfoButton];
        [self showPlanetaryWellbeingFooter];
    }
        
    [super viewDidLoad];
}

-(void)showPersonalWellbeingInfoButton {
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Info"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(showPersonalWellbeingInfo)];
    self.navigationItem.rightBarButtonItem = infoButton;    
}


-(void)showPlanetaryWellbeingInfoButton {
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Info"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(showPlanetarylWellbeingInfo)];
    self.navigationItem.rightBarButtonItem = infoButton;    
}


-(void)showPersonalWellbeingInfo {
    UIAlertView *personalWellbeingInfo =
    [[UIAlertView alloc] initWithTitle:@"Personal wellbeing recommendations" 
                               message:@"Recommended daily calorie intake varies from person to person, but there are guidelines for calorie requirements you can use as a starting point. UK Department of Health Estimated Average Requirements (EAR) are a daily calorie intake of 1940 calories per day for women and 2550 for men. \n\nHow many calories are needed each day can vary greatly depending on lifestyle and other factors. Factors that affect your personal daily calorie needs include your age, height and weight, your basic level of daily activity, and your body composition. \n\nIn order to lose weight you need to eat less calories per day than your body needs. \n\nTo lose 1lb a week you need a negative calorie balance of 500 calories per day. To lose weight at 2lb a week you need to reduce your calorie intake by 1000 calories a day."
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil];
    [personalWellbeingInfo show]; 
}


-(void)showPlanetarylWellbeingInfo {
    UIAlertView *personalWellbeingInfo =
    [[UIAlertView alloc] initWithTitle:@"Planetary wellbeing recommendations" 
                               message:@"Top tips on how to reduce your carbon footprint: \n\n1. Lighting/electricity. Low-cost or free options to reduce energy consumption include switching to low-energy lightbulbs or LED lighting, turning off lights and equipment when not in use and installing motion sensors or timer switches. \n\n2. Transportation. Newer is generally greener when it comes to vehicles, as older models are less efficient. But even older vehicles can be improved by fitting continuous regenerating traps (CRTs) and wind deflector kits. Maintaining the correct tyre pressure will also reduce fuel consumption. And consider using alternatives to fossil fuels like biodiesel, LPG and electricity. \n\n3. Water. Deal promptly with dripping taps and costly leaks and limit the amount of water used to flush toilets by switching to dual-flush models, or make older models more efficient by fitting water-displacement devices such as Hippos, which are cheap or free and easy to fit. Push taps or taps with sensors also save water, as does fitting flow regulators. \n\n4. Packaging. Swap single-use items like plastic cups for reusable options, and guest shampoo bottles and soap bars for refillable dispensers. Buy in bulk to save money and reduce landfill. \n\n5. Waste. Recycling produces less landfill and lowers the cost of waste disposal, as can balers and compactors. Recycling products like aluminium can raise money for charities, and recycling food waste by composting creates a useful product."
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil];
    [personalWellbeingInfo show]; 
}

- (void)viewDidUnload {
    
    self.sessionName = nil;
    self.date = nil;
    self.activity = nil;
    self.distanceTravelled = nil;
    self.totalTime = nil;
    self.highestSpeed = nil;
    self.averageGrade = nil;
    self.vo2 = nil;
    self.calories = nil;
    self.co2Emissions = nil;
    self.footerInfoTop = nil;
    self.footerInfoBody = nil;
    self.footerInfoBottom = nil;
    self.imageView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
