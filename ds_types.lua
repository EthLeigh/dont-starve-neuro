-- This is not a comprehensive list of the real fields/params, just the ones used in the mod

---@class GLOBAL
---@field BufferedAction fun(player: Player, ent: Entity, action: table): BufferedAction
---@field Vector3 fun(x: number, y: number, z: number): Vector3
---@field TheCamera Camera
---@field ACTIONS table<string, table>
---@field TheSim TheSim

-- Common Classes

---@class Vector3
---@field x number
---@field y number
---@field z number

-- Global classes

---@class TheSim
---@field FindEntities fun(self: TheSim, x: number, y: number, z: number, radius: number, must_have_tags?: string[], can_have_tags?: string[], must_one_of_tags?: string[]): Entity[]

---@class Entity
---@field name string
---@field prefab string
---@field Transform Transform
---@field components table<string, table>
---@field DoPeriodicTask fun(self: Player, duration: number, callback: function)

---@class Player: Entity
---@field components PlayerComponents

---@class Camera
---@field SetControllable fun(self: Camera, state: boolean)
---@field SetHeadingTarget fun(self: Camera, angle: number)
---@field Snap function

---@class Transform
---@field GetWorldPosition fun(): number, number, number

---@class PlayerComponents
---@field inventory Inventory
---@field locomotor Locomotor

---@class Inventory
---@field itemslots ItemSlot[]

---@class Locomotor
---@field PushAction fun(self: Locomotor, action: BufferedAction, force?: boolean)
---@field GoToPoint fun(self: Locomotor, position: Vector3, action?: BufferedAction, run?: boolean)

---@class ItemSlot
---@field name string
---@field prefab string
---@field components ItemSlotComponents

---@class ItemSlotComponents
---@field stackable ItemStackableComponent

---@class ItemStackableComponent
---@field StackSize fun(): integer

---@class BufferedAction
---@field AddSuccessAction fun(callback: function)
---@field AddFailAction fun(callback: function)

-- Global functions

---@param callback fun(inst: Player)
---@diagnostic disable-next-line: unused-local
function AddPlayerPostInit(callback) end

---@param callback function
---@diagnostic disable-next-line: unused-local
function AddSimPostInit(callback) end

--- Runs a `.lua` file (used in place of `import`)
---@param path string Relative path to the `.lua` file
---@diagnostic disable-next-line: unused-local
function modimport(path) end
