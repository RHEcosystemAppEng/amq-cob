package org.rh.cob.purge;

import javax.jms.Message;
import javax.jms.MessageProducer;
import javax.jms.Queue;
import javax.jms.QueueConnection;
import javax.jms.QueueConnectionFactory;
import javax.jms.QueueRequestor;
import javax.jms.QueueSession;
import javax.jms.Session;
import javax.jms.TextMessage;
import javax.naming.InitialContext;

import org.apache.activemq.artemis.api.core.management.ResourceNames;
import org.apache.activemq.artemis.api.jms.ActiveMQJMSClient;
import org.apache.activemq.artemis.api.jms.management.JMSManagementHelper;

public class PurgeQueue {

   private static final String QUEUE_NAME = "SampleQueue";
   private static final int TEST_MESSAGE_COUNT = 20;
   
   public static void main(final String[] args) throws Exception {
      QueueConnection connection = null;
      InitialContext initialContext = null;
      try {
         initialContext = new InitialContext();
         QueueConnectionFactory cf = (QueueConnectionFactory) initialContext.lookup("ConnectionFactory");
         connection = cf.createQueueConnection();
         QueueSession session = connection.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);
         
         // Send test messages to test removal later
         Queue queue = (Queue) initialContext.lookup("queue/exampleQueue");
         MessageProducer producer = session.createProducer(queue);
         for (int i = 1; i <= TEST_MESSAGE_COUNT; i++){
            String msg = "Text message #" + i;
            TextMessage message = session.createTextMessage(msg);
            System.out.println("Sent: " + msg);
            producer.send(message);
         }

         // Create Management Queue
         Queue managementQueue = ActiveMQJMSClient.createQueue("activemq.management");
         QueueRequestor requestor = new QueueRequestor(session, managementQueue);
         connection.start();

         // Send Remove Messages Management Message
         Message m = session.createMessage();
         JMSManagementHelper.putOperationInvocation(m, ResourceNames.QUEUE + QUEUE_NAME, "removeMessages", "");

         // Examine Results and Report
         Message reply = requestor.request(m);

         boolean success = JMSManagementHelper.hasOperationSucceeded(reply);
         System.out.println("Remove Messages operation has succeeded: " + success);

         Long count = (long)JMSManagementHelper.getResult(reply);
         System.out.println("Removed Message count: " + count);
      } finally {
         if (initialContext != null) {
            initialContext.close();
         }
         if (connection != null) {
            connection.close();
         }
      }
   }
}
