-- This is not a comprehensive list of the real fields/params, just the ones used in the mod

---@class GLOBAL
---@field BufferedAction fun(player: Player, ent: Entity, action: table): BufferedAction
---@field Vector3 fun(x: number, y: number, z: number): Vector3
---@field TheCamera Camera
---@field ACTIONS table<string, table>
---@field GROUND table<string, table>
---@field TheSim TheSim
---@field GetAllRecipes fun(): table<string, Recipe>
---@field GetPlayer fun(): Player
---@field GetMap fun(): Map
---@field GetWorld fun(): World
---@field tonumber fun(value: any): number?
---@field unpack function Type left anonymous to avoid complexity
---@field math mathlib
---@field setmetatable fun(table: table, metatable: table)
---@field next fun(table: table, index: any): any
---@field json json
---@field STRINGS STRINGS

-- Neuro API Classes

---@class IncomingAction
---@field command string
---@field data IncomingActionData

---@class IncomingActionData
---@field id string
---@field name string
---@field data string? JSON as a string

---@class Goal
---@field name string
---@field completion_check function

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

---@class PeriodicTask
---@field Cancel fun(self: PeriodicTask)

-- Global enums/constants

---@class STRINGS
---@field CHARACTER_NAMES table<string, string>
---@field CHARACTER_DESCRIPTIONS table<string, string>

-- Global classes

---@class TheSim
---@field QueryServer fun(self: TheSim, queryUrl: string, on_complete: fun(result: any, is_successful: boolean, result_code: number), type: "POST" | "GET", body: any?)
---@field FindEntities fun(self: TheSim, x: number, y: number, z: number, radius: number, must_have_tags?: string[], cant_have_tags?: string[], must_have_one_of_tags?: string[]): Entity[]
---@field SetPersistentString fun(self: TheSim, name: string, data: any, encode: boolean?, on_save: function?)
---@field GetPersistentString fun(self: TheSim, name: string, on_load: fun(success: boolean, data: string)?)

---@class json
---@field decode fun(string: string, start_position: integer?): table
---@field encode fun(value: any): string

---@class World
---@field components WorldComponents
---@field ListenForEvent fun(self: World, event_name: string, callback: fun(...: any))

---@class Entity: Instance
---@field name string
---@field prefab string
---@field Transform Transform
---@field components table<string, table>
---@field DoPeriodicTask fun(self: Player, duration: number, callback: function): PeriodicTask
---@field DoTaskInTime fun(self: Player, duration: number, callback: function)

---@class Instance
---@field ListenForEvent fun(self: Instance, event_name: string, callback: fun(inst: table<any, any>, data: table<any, any>), source: Instance?)
---@field RemoveEventCallback fun(self: Instance, event_name: string, callback: fun(inst: table<any, any>, data: table<any, any>), source: Instance?)
---@field OnSave fun(inst: Instance, data: table<any, any>)

---@class Component
---@field inst Instance

---@class Player: Entity
---@field LightWatcher LightWatcher
---@field profile Profile
---@field components PlayerComponents

---@class Profile
---@field GetValue fun(self: Profile, field: string): string

---@class Camera
---@field SetControllable fun(self: Camera, state: boolean)
---@field SetHeadingTarget fun(self: Camera, angle: number)
---@field Snap function

---@class Map
---@field GetTileAtPoint fun(self: Map, x: number, y: number, z: number): string

---@class Transform
---@field GetWorldPosition fun(): number, number, number

---@class LightWatcher
---@field GetLightValue fun(self: LightWatcher): number
---@field IsInLight fun(self: LightWatcher): boolean

---@class WorldComponents
---@field seasonmanager SeasonManager

---@class SeasonManager: Component
---@field GetSeasonString fun(self: SeasonManager): string
---@field preciptype string
---@field precip boolean | nil

---@class PlayerComponents
---@field health Health
---@field hunger Hunger
---@field sanity Sanity
---@field inventory Inventory
---@field locomotor Locomotor
---@field builder Builder
---@field combat Combat
---@field eater Eater
---@field talker Talker
---@field temperature Temperature

---@class Inventory: Component
---@field itemslots ItemSlot[]

---@class Locomotor: Component
---@field PushAction fun(self: Locomotor, action: BufferedAction, force?: boolean)
---@field GoToPoint fun(self: Locomotor, position: Vector3, action?: BufferedAction, run?: boolean)

---@class Combat: Component
---@field SetTarget fun(self: Combat, target: Entity)
---@field IsValidTarget fun(self: Combat, target: Entity): boolean

---@class Builder: Component
---@field CanBuild fun(self: Builder, recipe_name: string): boolean
---@field DoBuild fun(self: Builder, recipe_name: string, point?: Vector3, rotation?: number): boolean, string
---@field KnowsRecipe fun(self: Builder, recipe_name: string): boolean

---@class Health: Component
---@field GetPercent fun(self: Health): number
---@field IsHurt fun(self: Health): boolean

---@class Hunger: Component
---@field GetPercent fun(self: Hunger): number
---@field IsStarving fun(self: Hunger): boolean

---@class Eater: Component
---@field Eat fun(self: Eater, food: ItemSlot)

---@class Sanity: Component
---@field GetPercent fun(self: Sanity, use_penalty: boolean?): number
---@field GetRate fun(self: Sanity): number
---@field IsSane fun(self: Sanity): boolean

---@class Talker: Component
---@field Say fun(self: Talker, text: string, time: number, noanim: boolean?, force: boolean?, nobroadcast: boolean?, color: Color?)

---@class Temperature: Component
---@field GetCurrent fun(self: Temperature): number
---@field IsFreezing fun(self: Temperature): boolean

---@class ItemSlot
---@field name string
---@field prefab string
---@field components ItemSlotComponents

---@class ItemSlotComponents
---@field stackable ItemStackableComponent
---@field edible ItemEdibleComponent
---@field perishable ItemPerishableComponent

---@class ItemStackableComponent
---@field StackSize fun(): integer

---@class ItemEdibleComponent
---@field GetHunger fun(self: ItemEdibleComponent): integer
---@field GetSanity fun(self: ItemEdibleComponent): integer
---@field GetHealth fun(self: ItemEdibleComponent): integer

---@class ItemPerishableComponent
---@field IsFresh fun(self: ItemPerishableComponent): boolean
---@field IsStale fun(self: ItemPerishableComponent): boolean
---@field IsSpoiled fun(self: ItemPerishableComponent): boolean

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
