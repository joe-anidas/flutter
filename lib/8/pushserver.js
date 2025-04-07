const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

// Parse incoming request bodies in a middleware before your handlers, available under the req.body property
app.use(bodyParser.json());

// Example API to handle push notification requests
app.post('/send-notification', (req, res) => {
  const { message, deviceToken } = req.body;
  // Send push notification using FCM or other services
  // Replace this with your actual push notification logic
  console.log(`Sending push notification: ${message} to ${deviceToken}`);
  res.json({ success: true, message: 'Push notification sent successfully' });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
