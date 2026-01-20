# API Bridge Overview

These are some high level overviews on how the API Bridge works.

> [!IMPORTANT]
> The reason the API Bridge exists is that Don't Starve doesn't natively support WebSocket connections, only HTTP requests and only for POST and GET.

## Sending Context

> [!IMPORTANT]
> This example assumes that the player has taken damage/is being attacked

```mermaid
sequenceDiagram
    participant Neuro API
    participant Bridge
    participant Game

    Game->>Bridge: /api/actions/context
    Bridge->>Neuro API: context
```

## Receiving Actions

> [!IMPORTANT]
> This example assumes that Neuro is sending an action to eat food,
> but this will act the same for forced actions, registering actions, etc.

```mermaid
sequenceDiagram
    participant Neuro API
    participant Bridge
    participant Game

    Neuro API->>Bridge: action
    Note over Neuro API,Bridge: eat_food
    Bridge->>Bridge: Store action
    Note over Bridge,Bridge: If an action is already stored, it will be discarded<br/>and replaced with the new one.

    loop Every second
        Game->>Bridge: /api/actions/retrieve-pending

        opt Send if not already sent
            Bridge->>Game: Send new action
        end
    end

    Game->>Game: Handle the action
    Game->>Bridge: /api/action/result
    Note over Game,Bridge: Using the stored action's ID

    Bridge->>Neuro API: action/result
```
