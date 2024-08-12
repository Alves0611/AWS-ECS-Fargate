import "dotenv/config";

import { randomUUID } from "crypto";
import { createServer } from "http";

import express, { NextFunction, Request, Response } from "express";
import bodyParser from "body-parser";
import compression from "compression";
import cors from "cors";
import pinoHttp from "pino-http";
import helmet from "helmet";
import { eq } from "drizzle-orm";

import { db, todos } from "./db";
import { logger as pino, errorHandler } from "./utils";

const app = express();
const logger = pinoHttp({
  logger: pino,
  genReqId: function (req, res) {
    const existingID = req.id ?? req.headers["X-Request-Id"];

    if (existingID) {
      return existingID;
    }

    const id = randomUUID();
    res.setHeader("X-Request-Id", id);

    return id;
  },
});

app.use(bodyParser.json());
app.use(helmet());
app.use(cors());
app.use(compression());
app.use(logger);

app.get("/", (req: Request, res: Response) => {
  res.send("Hello AWS ECS Fargate com Terraform!");
});

app.get("/healthcheck", (req: Request, res: Response) => {
  try {
    res.status(200).send();
  } catch {
    res.status(500).send();
  }
});

app.get(
  "/api/v1/todos",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const limit = Number(req.query.limit) || 10;
      const results = await db
        .select({
          id: todos.id,
          task: todos.task,
          description: todos.description,
          isDone: todos.isDone,
        })
        .from(todos)
        .limit(limit >= 1 && limit <= 50 ? limit : 10);
      req.log.info({ results }, "Todos fetched successfully");
      res.json(results);
    } catch (error) {
      next(error);
    }
  }
);

app.get(
  "/api/v1/todos/:id",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await db
        .select()
        .from(todos)
        .where(eq(todos.id, req.params.id))
        .limit(1);
      req.log.info({ result }, "Todos fetched successfully");
      res.status(result.length === 1 ? 200 : 404).json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.post(
  "/api/v1/todos",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const todo = await db
        .insert(todos)
        .values({
          id: randomUUID(),
          task: req.body.task,
          description: req.body.description,
          ...(req.body.dueDate && { dueDate: new Date(req.body.dueDate) }),
        })
        .returning();
      req.log.info({ todo }, "Todo created successfully");
      res.status(201).json(todo);
    } catch (error) {
      next(error);
    }
  }
);

app.patch(
  "/api/v1/todos/:id",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const todo = await db
        .update(todos)
        .set({
          isDone: req.body.isDone,
          doneAt: new Date(req.body.doneAt),
          updatedAt: new Date(),
        })
        .where(eq(todos.id, req.params.id))
        .returning();
      req.log.info({ todo }, "Todo updated successfully");
      res.status(200).json(todo);
    } catch (error) {
      next(error);
    }
  }
);

app.delete(
  "/api/v1/todos/:id",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await db.delete(todos).where(eq(todos.id, req.params.id));
      req.log.info({ result }, "Todo deleted successfully");
      res.status(result.rowCount === 1 ? 200 : 404).json();
    } catch (error) {
      next(error);
    }
  }
);

app.get(
  "/api/v1/bitcoin",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const response = await fetch(
        "https://api.coindesk.com/v1/bpi/currentprice.json"
      );

      if (!response.ok) {
        res.status(500).json({ error: "Failed to fetch the Bitcoin prices." });
        return;
      }

      const prices = await response.json();
      req.log.info({ prices }, "Bitcoin prices fetched successfully");
      res.status(200).json(prices);
    } catch (error) {
      next(error);
    }
  }
);

app.use((err: any, req: Request, res: Response, next: any) => {
  errorHandler.handleError(err, res);
});

const server = createServer(app);
const APP_PORT = process.env.PORT || 3000;

server.listen(APP_PORT, () => {
  pino.info(`Server started on port ${APP_PORT}`);
});

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
