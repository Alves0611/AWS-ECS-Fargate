import express, { Request, Response } from 'express';
import { createServer } from 'http';

const app = express();

app.get("/", (req: Request, res: Response) => {
  res.send("Hello World");
})

app.get("/healthcheck", (req: Request, res: Response) => {
  try {
    res.status(200).send();
  } catch {
    res.status(500).send();
  }
});

const server = createServer(app);

const port = 8080;
server.listen(8080, () => {
  console.log(`Server is running on port ${port}`)
})