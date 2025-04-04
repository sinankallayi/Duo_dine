import { Client, Users } from 'node-appwrite';

// This Appwrite function will be executed every time your function is triggered
export default async ({ req, res, log, error }) => {
  // You can use the Appwrite SDK to interact with other services
  // For this example, we're using the Users service
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers['x-appwrite-key'] ?? '');
  
    const databases = new Databases(client);
    const databaseId = process.env.APPWRITE_DATABASE_ID; // Set this in your environment variables
  
    try {
      // Parse the event payload
      const payload = req.body ? JSON.parse(req.body) : null;
      if (!payload || !payload.$id) {
        return res.json({ success: false, message: "Invalid event payload" });
      }
  
      log(`Event payload: ${JSON.stringify(payload)}`);
  
      // Check if the event is relevant (order_item updated)
      if (payload.status === "foodDelivered"
  || payload.status === "orderCompleted"
  || payload.status === "orderCancelled"
  || payload.status === "orderFailed"
  || payload.status === "refunded"
  || payload.status === "returned"
      ) {
        const deliveryPersonId = payload.deliveryPerson_id; // Ensure this field exists in `order_item`
  log(`Delivery person ID: ${deliveryPersonId}`);
        if (!deliveryPersonId) {
          return res.json({ success: false, message: "No delivery person linked" });
        }
  
        // Determine new status for delivery_person
        const newStatus = "online";
  
        // Update the delivery_person status
        await databases.updateDocument(databaseId, "delivery_person", deliveryPersonId, {
          deliveryStatus: newStatus,
        });
  
        log(`Updated delivery_person ${deliveryPersonId} status to ${newStatus}`);
      }
    } catch (err) {
      error("Error updating delivery person status: " + err.message);
      return res.json({ success: false, error: err.message });
    }
  
    return res.json({ success: true, message: "Function executed successfully" });
  
};
