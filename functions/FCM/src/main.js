import { Client, Messaging, ID } from 'node-appwrite';

// This Appwrite function will be executed every time your function is triggered
export default async ({ req, res, log, error }) => {
  // You can use the Appwrite SDK to interact with other services
  // For this example, we're using the Users service
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers['x-appwrite-key'] ?? '');

  const messaging = new Messaging(client);

  if (req.path == '/send-push') {
    const { title, body, users } = JSON.parse(req.body);

    log('Sending push notification', { title, body, users });

    if (!title || !body) {
      return res.json({ error: 'Missing title or body' });
    }

    try {
      await messaging.createPush(
        ID.unique(),
        title,
        body,
        [],
        [users],
        [],
      );
      log('Push notification sent');
      return res.text('Push notification sent');
    } catch (e) {
      error('Failed to send push notification', e);
      return res.text('Failed to send push notification');
    }
  }

  return res.json({
    motto: "Build like a team of hundreds_",
    learn: "https://appwrite.io/docs",
    connect: "https://appwrite.io/discord",
    getInspired: "https://builtwith.appwrite.io",
  });
};
