import WebSocket from 'ws';
import { env } from '../env.js';
import { IncomingMessage, IncomingMessageSchema } from '../types/incomingMessageTypes.js';
import { handleNewIncomingMessage } from '../state/pendingIncomingAction.js';
import { logger } from '../server.js';
import allActions from '../constants/actionConstants.js';
import * as z from 'zod';
import { createActionResultMessage } from '../utils/outgoingMessageUtils.js';

let ws: WebSocket;

export const initWs = async (): Promise<void> => {
  ws = new WebSocket(env.NEURO_SDK_WS_URL);

  return new Promise<void>((resolve, reject) => {
    ws.on('open', () => {
      logger.info('Connected to Neuro API WebSocket');

      resolve();
    });

    ws.on('message', (data) => {
      let messageId;
      try {
        if (!Buffer.isBuffer(data)) {
          throw new TypeError('Received an action as something other than a buffer');
        }

        const dataString = data.toString('utf8');
        let dataObject;

        try {
          dataObject = JSON.parse(dataString);
        } catch (e) {
          throw new Error('Failed to parse incoming message string', { cause: e });
        }

        const parsedData = IncomingMessageSchema.safeParse(dataObject);

        if (!parsedData.success) {
          throw new Error('Failed to parse incoming message object', { cause: parsedData.error });
        }

        const parsedDataObject = parsedData.data;
        messageId = parsedDataObject.data.id;

        logger.info(
          { data: parsedDataObject },
          'Received data from Websocket, attempting to validate against action schema',
        );

        const actionSchema = allActions.find(
          (action) => action.name === parsedDataObject.data.name,
        );

        if (!actionSchema) {
          throw new Error('No action found with provided name: ' + parsedDataObject.data.name);
        }

        if (actionSchema.schema) {
          let dataObject;
          try {
            dataObject = JSON.parse(parsedDataObject.data.data!);
          } catch (e) {
            throw new Error('Failed to parse incoming message data string', { cause: e });
          }

          const parsedActionData = z
            .fromJSONSchema(actionSchema.schema)
            .safeParse(dataObject);

          if (!parsedActionData.success) {
            throw new Error('Failed to parse incoming message object', {
              cause: parsedActionData.error,
            });
          }
        }

        handleNewIncomingMessage(parsedDataObject);
      } catch (error) {
        console.error('An error occurred when processing incoming message.', error);

        const resultMessage = createActionResultMessage(
          messageId ?? '', // Shouldn't be empty unless catastrophe
          false,
          'An error occurred when processing incoming message. ' + error,
        );

        sendMessage(resultMessage);
      }
    });

    ws.on('error', reject);
  });
};

export const sendMessage = async (payload: unknown): Promise<void> => {
  if (ws) {
    if (ws.readyState === WebSocket.CLOSED) {
      logger.error('WebSocket connection has been closed, attempting to reconnect...');

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
