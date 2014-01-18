# librabbitmq-objc: Objective-C wrapper for librabbitmq-c

## Description

This is a simple Objective-C wrapper for librabbitmq-c, a C AMQP library from the people developing the RabbitMQ AMQP server.

## Requirements

 * Cocoa
 * librabbitmq-c including headers

## Build

There is nothing to build. Just include the source and header files into your Xcode project and link it againt librabbitmq-c.

## Usage

 * Establish a connection the server using `AMQPConnection`
 * Open a communication channel using `AMQPConnection - (AMQPChannel*)openChannel`
 * Create queues using `AMQPQueue` or exchanges using `AMQPExchange`
 * Connect queues to exchanges using `AMQPQueue`:
 
        - (void)bindToExchange:(AMQPExchange*)theExchange
                       withKey:(NSString*)bindingKey
 * To receive messages, use an `AMQPConsumer` bound to a queue:
 
           - (id)initForQueue:(AMQPQueue*)theQueue
                    onChannel:(AMQPChannel*)theChannel
          useAcknowledgements:(BOOL)ack
                  isExclusive:(BOOL)exclusive
         receiveLocalMessages:(BOOL)local
 * For ease of use, there is a complete threaded consumer implementation at `AMQPConsumerThread` using a `AMQPConsumerThreadDelegate` to handle received messages
 * To publish messages on an exchange, use `AMQPExchange`:
         
        - (void)publishMessage:(NSString*)body
               usingRoutingKey:(NSString*)theRoutingKey

## License

Copyright (C) 2014 *Prof. MAAD* aka Max Wolter
librabbitmq-objc is released under the terms of the GNU Lesser General Public License Version 3.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
