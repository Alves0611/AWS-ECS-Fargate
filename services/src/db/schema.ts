import {
  boolean,
  pgTable,
  text,
  uuid,
  varchar,
  timestamp,
} from "drizzle-orm/pg-core";

export const todos = pgTable("todos", {
  id: uuid("id").defaultRandom().primaryKey(),
  task: varchar("task", { length: 256 }).notNull(),
  description: text("description").notNull(),
  dueDate: timestamp("due_date"),
  isDone: boolean("is_done").default(false).notNull(),
  doneAt: timestamp("done_at"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
});
