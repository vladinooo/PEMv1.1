//
//  PEMCO2EmissionCalculations.m
//  PEM
//
//  Created by Vladimir Hartmann on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMCO2EmissionCalculations.h"

@implementation PEMCO2EmissionCalculations

/////////////////////////////////////////////////////////////
//
// All constants represent estimates for the Direct Emission
// as per the CarbonTrust document from August 2011 and
// does not include the Indirect Emission.
//
/////////////////////////////////////////////////////////////

// calculate traveling by car CO2 emissions
-(double)calculateTravelingByCarCo2emissions:(PEMLocationData *)locationDataObject {

    static double PETROL_CAR = 0.2086; // kgCO2 for average petrol car
    
    double distance = locationDataObject.distanceTravelled;
    
    distance = distance / 1000; // convert distance from m to km
    
    double co2Emissions = distance * PETROL_CAR;
    
    return co2Emissions;
}

// calculate traveling by bus CO2 emissions
-(double)calculateTravelingByBusCo2emissions:(PEMLocationData *)locationDataObject {
    
    static double BUS = 0.1488; // kgCO2/pkm for local bus
    
    double distance = locationDataObject.distanceTravelled;
    
    distance = distance / 1000; // convert distance from m to km
    
    double co2Emissions = distance * BUS;
    
    return co2Emissions;
}

// calculate traveling by train CO2 emissions
-(double)calculateTravelingByTrainCo2emissions:(PEMLocationData *)locationDataObject {
    
    static double TRAIN = 0.0565; // kgCO2/pkm for national rail
    
    double distance = locationDataObject.distanceTravelled;
    
    distance = distance / 1000; // convert distance from m to km
    
    double co2Emissions = distance * TRAIN;
    
    return co2Emissions;
}



@end
