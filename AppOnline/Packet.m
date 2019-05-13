//
//  Packet.m
//  AppOnline
//
//  Created by user on 2/16/15.
//  Copyright (c) 2015 nabeeg. All rights reserved.
//

#import "Packet.h"

@implementation Packet
{
    /// @description this is the actual dictionary that will hold all the contents of a packet
    NSMutableDictionary *_packet;
}

+ (Packet*)initFromDictionary:(NSDictionary *)dataPktKV
{
    Packet *pkt = [[Packet alloc] init];
    [pkt LoadFromDictionary:dataPktKV];
    return pkt;
}

- (void)LoadFromDictionary:(NSDictionary *)dataPktKV
{
    [_packet removeAllObjects];
    [_packet addEntriesFromDictionary:dataPktKV];
}

- (id)init
{
    self = [super init];
    if (self)
        _packet = [[NSMutableDictionary alloc] init];
    return self;
}


- (void)PacketAddOrSetForKey:(int)key Value:(NSObject *)value
{
    [_packet setObject:value forKey:[[NSNumber alloc] initWithInt:key]];
}

- (NSDictionary *)PacketGetPacketCopy
{
    return [[NSDictionary alloc] initWithDictionary:_packet];
}

- (NSObject *)PacketGetObjectForKey:(int)key
{
    return [_packet objectForKey:[[NSNumber alloc] initWithInt:key]];
}

- (NSString *)PacketGetStringForKey:(int)key
{
    return (NSString*)[self PacketGetObjectForKey:key];
}

- (int)PacketGetIntegerForKey:(int)key
{
    return [[self PacketGetStringForKey:key] intValue];
}

- (NSNumber*)PacketGetNumberForKey:(int)key
{
    return [[NSNumber alloc] initWithInt:[self PacketGetIntegerForKey:key]];
}

- (void)PacketRemoveForKey:(int)key
{
    [_packet removeObjectForKey:[[NSNumber alloc] initWithInt:key]];
}

-(void)PacketClearAllContents
{
    [_packet removeAllObjects];
}


/// @description this override returns packet xml string;
- (NSString *)description
{
    NSMutableString *packetXml = [[NSMutableString alloc] init];
    [packetXml appendString:@"<DocumentElement>"];
    
    for (NSNumber *key in _packet)
    {   //NSNumber *a = [[NSNumber alloc] initWithInteger:key];
        [packetXml appendString:@"<Kv>"];
        
        [packetXml appendString:@"<k>"];
        [packetXml appendFormat:@"%@",key]; // appendString:[[NSString alloc] initWithFormat:@"%i",(int)key]];
        [packetXml appendString:@"</k>"];
        
        [packetXml appendString:@"<v>"];
        [packetXml appendFormat:@"%@",[self PacketGetStringForKey:[key intValue]]];
        [packetXml appendString:@"</v>"];
        
        [packetXml appendString:@"</Kv>"];
    }
    
    [packetXml appendString:@"</DocumentElement>"];
    return [packetXml description];
}

/* sample xml for login packet
 
 <DocumentElement>
 <Kv>
 <k>1</k>
 <v>4.0.1.1</v>
 </Kv>
 <Kv>
 <k>2</k>
 <v>0</v>
 </Kv>
 <Kv>
 <k>3</k>
 <v>16</v>
 </Kv>
 <Kv>
 <k>101</k>
 <v>admin1</v>
 </Kv>
 <Kv>
 <k>102</k>
 <v>U+xTes8uEXD3YoZgKsoe7w==</v>
 </Kv>
 <Kv>
 <k>103</k>
 <v>BFEBFBFF0001067A..CN1374093902FB.</v>
 </Kv>
 <Kv>
 <k>104</k>
 <v>192.168.1.39</v>
 </Kv>
 <Kv>
 <k>105</k>
 <v>1 Processors with 4 Cores, Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz, 15.94 GB of RAM - Running InfinityChess (4.0.1.1)</v>
 </Kv>
 <Kv>
 <k>4</k>
 <v>1</v>
 </Kv>
 </DocumentElement>
 
*/

@end
