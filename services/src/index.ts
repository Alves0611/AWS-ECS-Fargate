import express from 'express';
import { createServer } from 'http';

const app = express();
const server = createServer(app);
const port = 8080;

server.listen(8080, () => {
  console.log(`Server is running on port ${port}`)
})