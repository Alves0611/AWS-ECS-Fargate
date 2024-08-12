import "dotenv/config";
import express, { Request, Response } from 'express';
import { createServer } from 'http';

import { db, todos } from "./db";
import { logger as pino, errorHandler } from "./utils";

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

app.get("/api/v1/todos", async (req: Request, res: Response) => {
  try {
    const result = await db.select().from(todos);
    res.json(result);
  } catch (error) {
    console.error(error)
    res.status(500).send();
  }
});


app.get("/api/v1/todos/:id", (req: Request, res: Response) => {
  res.send("GET TODO BY ID");
});

app.post("/api/v1/todos", (req: Request, res: Response) => {
  res.send("POST CREATE TODO");
});

app.patch("/api/v1/todos/:id", (req: Request, res: Response) => {
  res.send("UPDATE TODO BY ID");
});

app.delete("/api/v1/todos/:id", (req: Request, res: Response) => {
  res.send("DELETE TODO BY ID");
});

app.use((err: any, req: Request, res: Response, next: any) => {
  errorHandler.handleError(err, res);
});

const server = createServer(app);

const port = process.env.PORT ?? 8081;
server.listen(port, () => {
  console.log(`Server is running on port ${port}`)
})

process.on("unhandledRejection", (reason, promise) => {
  pino.error({ promise, reason }, "Unhandled Rejection");
});

process.on("uncaughtException", (error) => {
  pino.error({ error }, "Uncaught Exception");

  server.close(() => {
    pino.info("Server closed");
    process.exit(1);
  });

  // If the server hasn't finished in a reasonable time, give it 10 seconds and force exit
  setTimeout(() => process.exit(1), 10000).unref();
});