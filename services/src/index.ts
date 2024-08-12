import "dotenv/config";
import express, { NextFunction, Request, Response } from 'express';
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