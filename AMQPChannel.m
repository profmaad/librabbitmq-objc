//
//  AMQPChannel.m
//  Objective-C wrapper for librabbitmq-c
//
//  Copyright 2009 Max Wolter. All rights reserved.
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "AMQPChannel.h"

# import <amqp.h>
# import <amqp_framing.h>

@implementation AMQPChannel

@synthesize internalChannel = channel;
@synthesize connection;

- (id)init
{
	if(self = [super init])
	{
		channel = -1;
		connection = nil;
	}
	
	return self;
}
- (void)dealloc
{
	[self close];
	[connection release];
	
	[super dealloc];
}

- (void)openChannel:(unsigned int)theChannel onConnection:(AMQPConnection*)theConnection
{
	connection = [theConnection retain];
	channel = theChannel;
	
	amqp_channel_open(connection.internalConnection, channel);
	
	[connection checkLastOperation:@"Failed to open a channel"];
}
- (void)close
{
	amqp_channel_close(connection.internalConnection, channel, AMQP_REPLY_SUCCESS);
}

@end
