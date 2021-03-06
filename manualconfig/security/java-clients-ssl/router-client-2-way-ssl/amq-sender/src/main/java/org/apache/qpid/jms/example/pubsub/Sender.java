/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */
package org.apache.qpid.jms.example.pubsub;

import org.apache.qpid.jms.JmsConnection;

import javax.jms.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Sender {
	
	private static final int DEFAULT_COUNT = 10;
	private static final int DELIVERY_MODE = DeliveryMode.PERSISTENT;

	public static void main(String[] args) throws Exception {
		int count = DEFAULT_COUNT;
		if (args.length == 0) {
			System.out.println("Sending up to " + count + " messages.");
			System.out
					.println("Specify a message count as the program argument if you wish to send a different amount.");
		} else {
			count = Integer.parseInt(args[0]);
			System.out.println("Sending up to " + count + " messages.");
		}

		try {
			// The configuration for the Qpid InitialContextFactory has been supplied in
			// a jndi.properties file in the classpath, which results in it being picked
			// up automatically by the InitialContext constructor.
			Context context = new InitialContext();

			ConnectionFactory factory = (ConnectionFactory) context.lookup("publishSubscribeFactory");
//			Connection connection = factory.createConnection(System.getProperty("USER"),
//					System.getProperty("PASSWORD"));
			Connection connection = factory.createConnection();

			connection.setExceptionListener(new MyExceptionListener());
			connection.start();

			Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
			
			System.out.println("Sender connected to " + ((JmsConnection) connection).getConfiguredURI());

			Destination queue = (Destination) context.lookup("sampleQueue");
			MessageProducer messageProducer = session.createProducer(queue);

			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSZ");

			long start = System.currentTimeMillis();
			for (int i = 1; i <= count; i++) {
				TextMessage message = session.createTextMessage(
						"Text message. Message sent from " + ((JmsConnection) connection).getConfiguredURI()
								+ ". Timestamp: " + simpleDateFormat.format(new Date()));
				messageProducer.send(message, DELIVERY_MODE, Message.DEFAULT_PRIORITY, Message.DEFAULT_TIME_TO_LIVE);

				if (i % 10 == 0) {
					System.out.println("Sent message " + i);
				}
			}

			long finish = System.currentTimeMillis();
			long taken = finish - start;
			System.out.println("Sent " + count + " messages in " + taken + "ms");

			connection.close();
		} catch (Exception exp) {
			System.out.println("Caught exception, exiting.");
			exp.printStackTrace(System.out);
			System.exit(1);
		}
	}

	private static class MyExceptionListener implements ExceptionListener {
		@Override
		public void onException(JMSException exception) {
			System.out.println("Connection ExceptionListener fired, exiting.");
			exception.printStackTrace(System.out);
		}
	}

}
