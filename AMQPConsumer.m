//
//  AMQPConsumer.m
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

#import "AMQPConsumer.h"

# import <amqp.h>
# import <amqp_framing.h>
# import <string.h>
# import <stdlib.h>

# import "AMQPChannel.h"
# import "AMQPQueue.h"
# import "AMQPMessage.h"

@implementation AMQPConsumer

@synthesize internalConsumer = consumer;
@synthesize channel;
@synthesize queue;

- (id)initForQueue:(AMQPQueue*)theQueue onChannel:(AMQPChannel*)theChannel useAcknowledgements:(BOOL)ack isExclusive:(BOOL)exclusive receiveLocalMessages:(BOOL)local
{
	if(self = [super init])
	{
		channel = [theChannel retain];
		queue = [theQueue retain];
		
		amqp_basic_consume_ok_t *response = amqp_basic_consume(channel.connection.internalConnection, channel.internalChannel, queue.internalQueue, AMQP_EMPTY_BYTES, !local, !ack, exclusive);
		[channel.connection checkLastOperation:@"Failed to start consumer"];
		
		consumer = amqp_bytes_malloc_dup(response->consumer_tag);
	}
	
	return self;
}
- (void)dealloc
{
	amqp_bytes_free(consumer);
	[channel release];
	[queue release];
	
	[super dealloc];
}

- (AMQPMessage*)pop
{
	amqp_frame_t frame;
	int result = -1;
	size_t receivedBytes = 0;
	size_t bodySize = -1;
	amqp_bytes_t body;
	amqp_basic_deliver_t *delivery;
	amqp_basic_properties_t *properties;
	
	AMQPMessage *message = nil;
	
	amqp_maybe_release_buffers(channel.connection.internalConnection);
	
	while(!message)
	{
		// a complete message delivery consists of at least three frames:
		
		// Frame #1: method frame with method basic.deliver
		result = amqp_simple_wait_frame(channel.connection.internalConnection, &frame);
		if(result <= 0) { return nil; }
		
		if(frame.frame_type != AMQP_FRAME_METHOD || frame.payload.method.id != AMQP_BASIC_DELIVER_METHOD) { continue; }
		
		delivery = (amqp_basic_deliver_t*)frame.payload.method.decoded;
		
		// Frame #2: header frame containing body size
		result = amqp_simple_wait_frame(channel.connection.internalConnection, &frame);
		if(result <= 0) { return nil; }
		
		if(frame.frame_type != AMQP_FRAME_HEADER)
		{
			return nil;
		}
		
		properties = (amqp_basic_properties_t*)frame.payload.properties.decoded;
		
		bodySize = frame.payload.properties.body_size;
		receivedBytes = 0;
		body = amqp_bytes_malloc(bodySize);
		
		// Frame #3+: body frames
		while(receivedBytes < bodySize)
		{
			result = amqp_simple_wait_frame(channel.connection.internalConnection, &frame);
			if(result <= 0) { return nil; }
			
			if(frame.frame_type != AMQP_FRAME_BODY)
			{
				return nil;
			}
			
			receivedBytes += frame.payload.body_fragment.len;
			memcpy(body.bytes, frame.payload.body_fragment.bytes, frame.payload.body_fragment.len);
		}
		
	
		message = [AMQPMessage messageFromBody:body withDeliveryProperties:delivery withMessageProperties:properties receivedAt:[NSDate date]];
		
		amqp_bytes_free(body);
	}
	
	return message;
}

@end
