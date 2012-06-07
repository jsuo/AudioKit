//  mySoundGenerator.m

#import "SoundGenerator.h"

typedef enum
{
    kPValuePitchTag=4,
}kPValueTag;

@implementation SoundGenerator

-(id) initWithOrchestra:(CSDOrchestra *)newOrchestra {
    self = [super initWithOrchestra:newOrchestra];
    if (self) {
        // CSDFunctionTable * iSine = [[CSDFunctionTable alloc] initWithType:kGenSine UsingSize:iFTableSize];
        
        CSDSineTable * iSine = [[CSDSineTable alloc] initWithOutput:@"iSine" TableSize:4096 PartialStrengths:@"1"];
        [self addFunctionStatement:iSine];
        
        //H4Y - ARB: This assumes that CSDFunctionTable is ftgentmp
        //  and will look for [CSDFunctionTable output] during csd conversion
        myOscillator = [[CSDOscillator alloc] initWithOutput:FINAL_OUTPUT
                                                   Amplitude:[CSDParam paramWithFloat:0.4]
                                                      kPitch:[CSDParam paramWithPValue:kPValuePitchTag]
                                               FunctionTable:iSine];
        [self addOpcode:myOscillator];
    }
    return self;
}
/*
-(id) initUsingOpcodes:(CSDOrchestra *)newOrchestra {
    self = [super init];
    if (self) {
        
        CSDOscillator * aOut = [CSDOscillator oscillatorWithAmplitude:[CSDParam paramFromFloat:iAmplitude] 
                                                            Frequency:iFrequency
                                                        FunctionTable:[CSDParam paramFromOpcode:iSine]];
         
        CSDOscillator * aOut = [[CSDOscillator alloc] initWithAmplitude:iAmplitude 
                                                              Frequency:iFrequency
                                                          FunctionTable:iSine];
        [self addOpcode:aOut];
        
        /CSDOut * out = [[CSDOut alloc] initWithOut:aOut];
        [self addOpcode:out];

        
    }
    return self;
}
*/


-(NSString *) textForOrchestra {
    NSString * text=  @"iSine ftgentmp 0, 0, 4096, 10, 1\n"
                       "aOut1 oscil 0.4, p4, iSine\n"
                       "out aOut1";
    return text;
}

-(void) playNoteForDuration:(float)dur Pitch:(float)pitch {
    int instrumentNumber = [[orchestra instruments] indexOfObject:self] + 1;
    NSString * note = [NSString stringWithFormat:@"%0.2f %0.2f", dur, pitch];
    [[CSDManager sharedCSDManager] playNote:note OnInstrument:instrumentNumber];
}

@end
