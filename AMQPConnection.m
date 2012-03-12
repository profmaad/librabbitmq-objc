//
//  AMQPConnection.m
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

#import "AMQPConnection.h"

# import <amqp.h>
# import <amqp_framing.h>
# import <unistd.h>

# import "AMQPChannel.h"

@implementation AMQPConnection

@synthesize internalConnection = connection;

- (id)init
{
	if(self = [super init])
	{
		connection = amqp_new_connection();
		nextChannel = 1;
	}
	
	return self;
}
- (void)dealloc
{
	[self disconnect];
	
	amqp_destroy_connection(connection);
	
	[super dealloc];
}

- (void)connectToHost:(NSString*)host onPort:(int)port
{
	socketFD = amqp_open_socket([host UTF8String], port);
	
	if(socketFD < 0)
	{
		[NSException raise:@"AMQPConnectionException" format:@"Unable to open socket to host %@ on port %d", host, port];
	}

	amqp_set_sockfd(connection, socketFD);
}
- (void)loginAsUser:(NSString*)username withPasswort:(NSString*)password onVHost:(NSString*)vhost
{
	amqp_rpc_reply_t reply = amqp_login(connection, [vhost UTF8String], 0, 131072, 0, AMQP_SASL_METHOD_PLAIN, [username UTF8String], [password UTF8String]);
	
	if(reply.reply_type != AMQP_RESPONSE_NORMAL)
	{
		[NSException raise:@"AMQPLoginException" format:@"Failed to login to server as user %@ on vhost %@ using password %@: %@", username, vhost, password, [self errorDescriptionForReply:reply]];
	}
}
- (void)disconnect
{
	amqp_rpc_reply_t reply = amqp_connection_close(connection, AMQP_REPLY_SUCCESS);
	
	if(reply.reply_type != AMQP_RESPONSE_NORMAL)
	{
		[NSException raise:@"AMQPConnectionException" format:@"Unable to disconnect from host: %@", [self errorDescriptionForReply:reply]];
	}
	
	close(socketFD);
}

- (void)checkLastOperation:(NSString*)context
{
	amqp_rpc_reply_t reply = amqp_get_rpc_reply(connection);
	
	if(reply.reply_type != AMQP_RESPONSE_NORMAL)
	{
		[NSException raise:@"AMQPException" format:@"%@: %@", context, [self errorDescriptionForReply:reply]];
	}
}

- (AMQPChannel*)openChannel
{
	AMQPChannel *channel = [[AMQPChannel alloc] init];
	[channel openChannel:nextChannel onConnection:self];
	
	nextChannel++;

	return [channel autorelease];
}

@end
