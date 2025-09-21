let gameStarted = false;

export const setGameStarted = (state: boolean): void => {
  gameStarted = state;
};

export const getGameStarted = (): boolean => gameStarted;
