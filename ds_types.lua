-- This is not a comprehensive list of the real fields/params, just the ones used in the mod

---@class GLOBAL
---@field BufferedAction fun(player: Player, ent: Entity, action: table): BufferedAction
---@field Vector3 fun(x: number, y: number, z: number): Vector3
---@field TheCamera Camera
---@field ACTIONS table<string, table>
---@field TheSim TheSim
---@field GetAllRecipes fun(): table<string, Recipe>
---@field GetPlayer fun(): Player

-- Common Classes

---@class Vector3
---@field x number
---@field y number
---@field z number

---@class Color
---@field r number
---@field g number
---@field b number
---@field a number

-- Global classes

---@class TheSim
---@field FindEntities fun(self: TheSim, x: number, y: number, z: number, radius: number, must_have_tags?: string[], cant_have_tags?: string[], must_have_one_of_tags?: string[]): Entity[]

---@class Entity
---@field name string
---@field prefab string
---@field Transform Transform
---@field components table<string, table>
---@field DoPeriodicTask fun(self: Player, duration: number, callback: function)
---@field DoTaskInTime fun(self: Player, duration: number, callback: function)

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
---@field builder Builder
---@field combat Combat
---@field talker Talker

---@class Inventory
---@field itemslots ItemSlot[]

---@class Locomotor
---@field PushAction fun(self: Locomotor, action: BufferedAction, force?: boolean)
---@field GoToPoint fun(self: Locomotor, position: Vector3, action?: BufferedAction, run?: boolean)

---@class Combat
---@field SetTarget fun(self: Combat, target: Entity)
---@field IsValidTarget fun(self: Combat, target: Entity): boolean

---@class Builder
---@field CanBuild fun(self: Builder, recipe_name: string): boolean
---@field DoBuild fun(self: Builder, recipe_name: string, point?: Vector3, rotation?: number): boolean, string
---@field KnowsRecipe fun(self: Builder, recipe_name: string): boolean

---@class Talker
---@field Say fun(self: Talker, text: string, time: number, noanim: boolean?, force: boolean?, nobroadcast: boolean?, color: Color?)

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

---@class Recipe
---@field name string

---@class Recipes
---@type Recipe[]

-- Global functions

---@param callback fun(inst: Player)
---@diagnostic disable-next-line: unused-local
function AddPlayerPostInit(callback) end

---@param callback function
---@diagnostic disable-next-line: unused-local
function AddSimPostInit(callback) end

---@param class_name string
---@param callback function
---@diagnostic disable-next-line: unused-local
function AddClassPostConstruct(class_name, callback) end

--- Runs a `.lua` file (used in place of `import`)
---@param path string Relative path to the `.lua` file
---@diagnostic disable-next-line: unused-local
function modimport(path) end
