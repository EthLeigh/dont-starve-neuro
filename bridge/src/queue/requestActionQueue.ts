import type { IncomingAction } from '../types/incomingMessages.js';

export class RequestActionQueue {
  private queue: IncomingAction[] = [];

  enqueue(action: IncomingAction): void {
    this.queue.push(action);
  }

  getAll(): IncomingAction[] {
    return this.queue;
  }

  clearAll(): void {
    this.queue = [];
  }
}
