//
//  AMQPConsumerThread.m
//  This file is part of librabbitmq-objc.
//  Copyright (C) 2014 *Prof. MAAD* aka Max Wolter
//  librabbitmq-objc is released under the terms of the GNU Lesser General Public License Version 3.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//  
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "AMQPConsumerThread.h"

# import "AMQPConsumer.h"
# import "AMQPMessage.h"

@implementation AMQPConsumerThread

@synthesize delegate;

- (id)initWithConsumer:(AMQPConsumer *)theConsumer
{
	if(self = [super init])
	{
		consumer = [theConsumer retain];
	}
	
	return self;
}
- (void)dealloc
{
	[consumer release];
	
	[super dealloc];
}

- (void)main
{
	NSAutoreleasePool *localPool;
	
	while(![self isCancelled])
	{
		localPool = [[NSAutoreleasePool alloc] init];
		
		AMQPMessage *message = [consumer pop];
		if(message)
		{
			[delegate performSelectorOnMainThread:@selector(amqpConsumerThreadReceivedNewMessage:) withObject:message waitUntilDone:NO];
		}
		
		[localPool drain];
	}
}

@end
