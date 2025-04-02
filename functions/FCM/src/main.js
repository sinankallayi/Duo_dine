import { Client, Messaging, ID, Account } from 'node-appwrite';

export default async ({ req, res, log, error }) => {
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers['x-appwrite-key'] ?? '');

  const messaging = new Messaging(client);
  const account = new Account(client);

  if (req.path === '/send-push') {
    const { title, body, users } = JSON.parse(req.body);

    if (!title || !body || !users) {
      return res.json({ error: 'Missing title, body, or users' });
    }

    log('Sending push notification', { title, body, users });

    try {
      await messaging.createPush(ID.unique(), title, body, [], [users], []);
      log('Push notification sent');
      return res.text('Push notification sent');
    } catch (e) {
      error('Failed to send push notification', e);

      // Handle expired token error
      if (e.message.includes("Expired device token")) {
        log('Expired token detected. Removing it...');
        
        try {
          await account.deletePushTarget(users);
          log('Expired push target removed');
        } catch (deleteError) {
          error('Failed to remove expired push target', deleteError);
        }
      }

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
