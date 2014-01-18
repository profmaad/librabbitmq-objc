//
//  AMQPConnection.h
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

#import <Cocoa/Cocoa.h>

# import <amqp.h>

# import "AMQPObject.h"

@class AMQPChannel;

@interface AMQPConnection : AMQPObject
{
	amqp_connection_state_t connection;
	int socketFD;
	
	unsigned int nextChannel;
}

@property (readonly) amqp_connection_state_t internalConnection;

- (id)init;
- (void)dealloc;

- (void)connectToHost:(NSString*)host onPort:(int)port;
- (void)loginAsUser:(NSString*)username withPasswort:(NSString*)password onVHost:(NSString*)vhost;
- (void)disconnect; // all channels have to be closed before closing the connection

- (void)checkLastOperation:(NSString*)context;

- (AMQPChannel*)openChannel;

@end
