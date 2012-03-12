//
//  AMQPMessage.m
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

#import "AMQPMessage.h"

# import <amqp.h>
# import <amqp_framing.h>

# define AMQP_BYTES_TO_NSSTRING(x) [[NSString alloc] initWithBytes:x.bytes length:x.len encoding:NSUTF8StringEncoding]

@implementation AMQPMessage

@synthesize body;

@synthesize contentType;
@synthesize contentEncoding;
@synthesize headers;
@synthesize deliveryMode;
@synthesize priority;
@synthesize correlationID;
@synthesize replyToQueueName;
@synthesize expiration;
@synthesize messageID;
@synthesize timestamp;
@synthesize type;
@synthesize userID;
@synthesize appID;
@synthesize clusterID;

@synthesize consumerTag;
@synthesize deliveryTag;
@synthesize redelivered;
@synthesize exchangeName;
@synthesize routingKey;

@synthesize read;
@synthesize receivedAt;

+ (AMQPMessage*)messageFromBody:(amqp_bytes_t)theBody withDeliveryProperties:(amqp_basic_deliver_t*)theDeliveryProperties withMessageProperties:(amqp_basic_properties_t*)theMessageProperties receivedAt:(NSDate*)receiveTimestamp
{
	AMQPMessage *message = [[AMQPMessage alloc] initWithBody:theBody withDeliveryProperties:theDeliveryProperties withMessageProperties:theMessageProperties receivedAt:receiveTimestamp];
	
	return [message autorelease];
}

- (id)initWithBody:(amqp_bytes_t)theBody withDeliveryProperties:(amqp_basic_deliver_t*)theDeliveryProperties withMessageProperties:(amqp_basic_properties_t*)theMessageProperties receivedAt:(NSDate*)receiveTimestamp
{
	if(!theDeliveryProperties || !theMessageProperties) { return nil; }
	
	if(self = [super init])
	{
		body = AMQP_BYTES_TO_NSSTRING(theBody);
		
		consumerTag = AMQP_BYTES_TO_NSSTRING(theDeliveryProperties->consumer_tag);
		deliveryTag = theDeliveryProperties->delivery_tag;
		redelivered = theDeliveryProperties->redelivered;
		exchangeName = AMQP_BYTES_TO_NSSTRING(theDeliveryProperties->exchange);
		routingKey = AMQP_BYTES_TO_NSSTRING(theDeliveryProperties->routing_key);
		
		if(theMessageProperties->_flags & AMQP_BASIC_CONTENT_TYPE_FLAG) { contentType = AMQP_BYTES_TO_NSSTRING(theMessageProperties->content_type); } else { contentType = nil; }
		if(theMessageProperties->_flags & AMQP_BASIC_CONTENT_ENCODING_FLAG) { contentEncoding = AMQP_BYTES_TO_NSSTRING(theMessageProperties->content_encoding); } else { contentEncoding = nil; }
		if(theMessageProperties->_flags & AMQP_BASIC_HEADERS_FLAG) { headers = theMessageProperties->headers; } else { headers = AMQP_EMPTY_TABLE; }
		if(theMessageProperties->_flags & AMQP_BASIC_DELIVERY_MODE_FLAG) { deliveryMode = theMessageProperties->delivery_mode; } else { deliveryMode = 0; }
		if(theMessageProperties->_flags & AMQP_BASIC_PRIORITY_FLAG) { priority = theMessageProperties->priority; } else { priority = 0; }
		if(theMessageProperties->_flags & AMQP_BASIC_CORRELATION_ID_FLAG) { correlationID = AMQP_BYTES_TO_NSSTRING(theMessageProperties->correlation_id); } else { correlationID = nil; }
		if(theMessageProperties->_flags & AMQP_BASIC_REPLY_TO_FLAG) { replyToQueueName = AMQP_BYTES_TO_NSSTRING(theMessageProperties->reply_to); } else { replyToQueueName = nil; }
		if(theMessageProperties->_flags & AMQP_BASIC_EXPIRATION_FLAG) { expiration = AMQP_BYTES_TO_NSSTRING(theMessageProperties->expiration); } else { expiration = nil; }
		if(theMessageProperties->_flags & AMQP_BASIC_MESSAGE_ID_FLAG) { messageID = AMQP_BYTES_TO_NSSTRING(theMessageProperties->message_id); } else { messageID = nil; }
		if(theMessageProperties->_flags & AMQP_BASIC_TIMESTAMP_FLAG) { timestamp = theMessageProperties->timestamp; } else { timestamp = 0; }
		if(theMessageProperties->_flags & AMQP_BASIC_TYPE_FLAG) { type = AMQP_BYTES_TO_NSSTRING(theMessageProperties->type); } else { type = nil; }
		if(theMessageProperties->_flags & AMQP_BASIC_USER_ID_FLAG) { userID = AMQP_BYTES_TO_NSSTRING(theMessageProperties->user_id); } else { userID = nil; }
		if(theMessageProperties->_flags & AMQP_BASIC_APP_ID_FLAG) { appID = AMQP_BYTES_TO_NSSTRING(theMessageProperties->app_id); } else { appID = nil; }
		if(theMessageProperties->_flags & AMQP_BASIC_CLUSTER_ID_FLAG) { clusterID = AMQP_BYTES_TO_NSSTRING(theMessageProperties->cluster_id); } else { clusterID = nil; }
		
		read = NO;
		receivedAt = [receiveTimestamp copy];
	}
	
	return self;
}
- (id)initWithAMQPMessage:(AMQPMessage*)theMessage
{
	if(self = [super init])
	{
		body = [theMessage.body copy];
		
		consumerTag			= [theMessage.consumerTag copy];
		deliveryTag			= theMessage.deliveryTag;
		redelivered			= theMessage.redelivered;
		exchangeName		= [theMessage.exchangeName copy];
		routingKey			= [theMessage.routingKey copy];
		
		contentType			= [theMessage.contentType copy];
		contentEncoding		= [theMessage.contentEncoding copy];
		headers				= theMessage.headers;
		deliveryMode		= theMessage.deliveryMode;
		priority			= theMessage.priority;
		correlationID		= [theMessage.correlationID copy];
		replyToQueueName	= [theMessage.replyToQueueName copy];
		expiration			= [theMessage.expiration copy];
		messageID			= [theMessage.messageID copy];
		timestamp			= theMessage.timestamp;
		type				= [theMessage.type copy];
		userID				= [theMessage.userID copy];
		appID				= [theMessage.appID copy];
		clusterID			= [theMessage.clusterID copy];
		
		read				= theMessage.read;
		receivedAt			= [theMessage.receivedAt copy];
	}
	
	return self;
}
- (void)dealloc
{
	[body release];
	[consumerTag release];
	[exchangeName release];
	[routingKey release];
	[contentType release];
	[contentEncoding release];
	[correlationID release];
	[replyToQueueName release];
	[expiration release];
	[messageID release];
	[type release];
	[userID release];
	[appID release];
	[clusterID release];
	[receivedAt release];
	
	[super dealloc];
}
- (id)copyWithZone:(NSZone*)zone
{
	AMQPMessage *newMessage = [[AMQPMessage allocWithZone:zone] initWithAMQPMessage:self];
	
	return newMessage;
}

@end
