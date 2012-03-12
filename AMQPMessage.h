//
//  AMQPMessage.h
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

#import <Cocoa/Cocoa.h>

# import <amqp.h>
# import <amqp_framing.h>

# import "AMQPObject.h"

@class AMQPConsumer;

@interface AMQPMessage : NSObject
{
	NSString *body;
	
	// from properties
	NSString *contentType;
	NSString *contentEncoding;
	amqp_table_t headers;
	uint8 deliveryMode;
	uint8 priority;
	NSString *correlationID;
	NSString *replyToQueueName;
	NSString *expiration;
	NSString *messageID;
	uint64 timestamp;
	NSString *type;
	NSString *userID;
	NSString *appID;
	NSString *clusterID;
	
	//from method
	NSString *consumerTag;
	uint64 deliveryTag;
	BOOL redelivered;
	NSString *exchangeName;
	NSString *routingKey;
	
	BOOL read;
	NSDate *receivedAt;
}

@property (readonly) NSString *body;

@property (readonly) NSString *contentType;
@property (readonly) NSString *contentEncoding;
@property (readonly) amqp_table_t headers;
@property (readonly) uint8 deliveryMode;
@property (readonly) uint8 priority;
@property (readonly) NSString *correlationID;
@property (readonly) NSString *replyToQueueName;
@property (readonly) NSString *expiration;
@property (readonly) NSString *messageID;
@property (readonly) uint64 timestamp;
@property (readonly) NSString *type;
@property (readonly) NSString *userID;
@property (readonly) NSString *appID;
@property (readonly) NSString *clusterID;

@property (readonly) NSString *consumerTag;
@property (readonly) uint64 deliveryTag;
@property (readonly) BOOL redelivered;
@property (readonly) NSString *exchangeName;
@property (readonly) NSString *routingKey;

@property BOOL read;
@property (readonly) NSDate *receivedAt;

+ (AMQPMessage*)messageFromBody:(amqp_bytes_t)theBody withDeliveryProperties:(amqp_basic_deliver_t*)theDeliveryProperties withMessageProperties:(amqp_basic_properties_t*)theMessageProperties receivedAt:(NSDate*)receiveTimestamp;

- (id)initWithBody:(amqp_bytes_t)theBody withDeliveryProperties:(amqp_basic_deliver_t*)theDeliveryProperties withMessageProperties:(amqp_basic_properties_t*)theMessageProperties receivedAt:(NSDate*)receiveTimestamp;
- (id)initWithAMQPMessage:(AMQPMessage*)theMessage;
- (void)dealloc;

@end
