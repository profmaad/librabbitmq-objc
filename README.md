# librabbitmq-objc: Objective-C wrapper for librabbitmq-c

## Description

This is a simple Objective-C wrapper for librabbitmq-c, a C AMQP library from the people developing the RabbitMQ AMQP server.

## Requirements

 * Cocoa
 * librabbitmq-c including headers

## Build

There is nothing to build. Just include the source and header files into your X-Code project and link it againt librabbitmq-c.

## Usage

 * Establish a connection the server using AMQPConnection
 * Open a communication channel using AMQPConnection::openChannel
 * Create queues using AMQPQueue or exchanges using AMQPExchange
 * Connect queues to exchanges using AMQPQueue::bindToExchange
 * To receive messages, use an AMQPConsumer bound to a queue (AMQPConsumer::initForQueue...)
 * For ease of use, there is a complete threaded consumer implementation at AMQPConsumerThread using a AMQPConsumerThreadDelegate to handle received messages
 * To publish messages on an exchange, use AMQPExchange::publishMessage

## License

Copyright (C) 2009 *Prof. MAAD* aka Max Wolter

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 3
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
