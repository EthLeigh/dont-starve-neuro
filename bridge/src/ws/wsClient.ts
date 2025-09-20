import WebSocket from 'ws';
import { env } from '../env.js';
import { IncomingActionSchema } from '../types/incomingMessages.js';
import { handleNewIncomingAction } from '../state/pendingIncomingAction.js';

let ws: WebSocket;

export const initWs = async (): Promise<void> => {
  ws = new WebSocket(env.NEURO_SDK_WS_URL);

  return new Promise<void>((resolve, reject) => {
    ws.on('open', () => {
      console.info('Connected to Neuro API WebSocket');

      resolve();
    });

    ws.on('message', (data) => {
      if (!Buffer.isBuffer(data)) {
        return console.error('Received an action as something other than a buffer');
      }

      const dataString = data.toString('utf8');
      let dataObject;

      try {
        dataObject = JSON.parse(dataString);
      } catch (e) {
        return console.error('Failed to parse incoming action string', e);
      }

      const parsedData = IncomingActionSchema.safeParse(dataObject);

      if (!parsedData.success) {
        return console.error('Failed to parse incoming action object', parsedData.error);
      }

      handleNewIncomingAction(parsedData.data);
    });

    ws.on('error', reject);
  });
};

export const sendMessage = async (payload: unknown): Promise<void> => {
  if (ws) {
    if (ws.readyState === WebSocket.CLOSED) {
      console.error('WebSocket connection has been closed, attempting to reconnect...');

      try {
        await initWs();
      } catch (e) {
        throw new Error('Failed to initialize WebSocket connection', { cause: e });
      }
    } else if (ws.readyState !== WebSocket.OPEN) {
      throw new Error('WebSocket connection is not ready');
    }
  } else {
    throw new Error('WebSocket connection has not been initialized');
  }

  return new Promise<void>((resolve, reject) => {
    ws.send(JSON.stringify(payload), (err) => {
      if (err) {
        reject(new Error('An error occurred with the WebSocket', { cause: err }));
      } else {
        resolve();
      }
    });
  });
};
