import WebSocket from 'ws';
import { env } from '../env.js';
import { requestActionQueue } from '../server.js';
import { type IncomingAction } from '../types/incomingMessages.js';

let ws: WebSocket;

export const initWs = async (): Promise<void> => {
  ws = new WebSocket(env.NEURO_SDK_WS_URL);

  return new Promise<void>((resolve, reject) => {
    ws.on('open', () => {
      console.info('Connected to Neuro API WebSocket');

      resolve();
    });

    ws.on('message', (data) => {
      // TODO: Improve type validation
      const action = data as unknown as IncomingAction;

      requestActionQueue.enqueue(action);
    });

    ws.on('error', reject);
  });
};

export const sendMessage = async (payload: unknown): Promise<void> => {
  if (!ws || ws.readyState !== WebSocket.OPEN) {
    throw new Error('Neuro API WebSocket not ready');
  }

  return new Promise<void>((resolve, reject) => {
    ws.send(JSON.stringify(payload), (err) => {
      if (err) {
        reject(new Error('An error occurred with the Neuro API WebSocket', { cause: err }));
      } else {
        resolve();
      }
    });
  });
};
