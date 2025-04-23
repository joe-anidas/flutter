// server.js
const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

app.use(bodyParser.json());

app.post('/send-notification', (req, res) => {
  const { message, deviceToken } = req.body;
  console.log(`Sending: ${message} to ${deviceToken}`);
  res.json({ success: true });
});

app.listen(port, () => console.log(`Server at http://localhost:${port}`));
