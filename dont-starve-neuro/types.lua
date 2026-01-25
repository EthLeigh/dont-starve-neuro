-- This is not a comprehensive list of the real fields/params, just the ones used in the mod

---@class GLOBAL
---@field CHEATS_ENABLED boolean
---@field require fun(file: string)
---@field TheFrontEnd table
---@field StartNextInstance fun(in_params: table?)
---@field SaveGameIndex table
---@field RESET_ACTION table<string, any>
---@field BufferedAction fun(player: Player, ent: Entity, action: table, invobject: ItemSlot?, pos: Vector3?): BufferedAction
---@field Vector3 fun(x: number, y: number, z: number): Vector3
---@field TheCamera Camera
---@field ACTIONS table<string, table>
---@field GROUND table<string, table>
---@field TheSim TheSim
---@field GetAllRecipes fun(self: GLOBAL): table<string, Recipe>
---@field GetPlayer fun(self: GLOBAL): Player
---@field GetMap fun(self: GLOBAL): Map
---@field GetWorld fun(self: GLOBAL): World
---@field GetClock fun(self: GLOBAL): Clock
---@field tonumber fun(value: any): number?
---@field unpack function Type left anonymous to avoid complexity
---@field math mathlib
---@field setmetatable fun(table: table, metatable: table)
---@field next next
---@field json json
---@field STRINGS STRINGS
---@field RequestShutdown fun(callback: function)
---@field SpawnPrefab fun(name: string): Entity

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

-- Aliases

---@alias EventCallback fun(...: any)

---@generic K, V
---@alias next fun(table: table<K, V>, index: K|nil): K, V

-- Global enums/constants

---@class STRINGS
---@field CHARACTERS table<string, any>
---@field CHARACTER_NAMES table<string, string>
---@field CHARACTER_DESCRIPTIONS table<string, string>
---@field NAMES table<string, string>

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
---@field ListenForEvent fun(self: World, event_name: string, callback: EventCallback)

---@class Entity: Instance
---@field name string
---@field prefab string
---@field Transform Transform
---@field components table<string, table>
---@field DoPeriodicTask fun(self: Player, duration: number, callback: function): PeriodicTask
---@field DoTaskInTime fun(self: Player, duration: number, callback: function)
---@field AddTransform fun(): Transform
---@field AddAnimState fun(): AnimState
---@field AddSoundEmitter fun(): SoundEmitter
---@field AddDynamicShadow fun(): DynamicShadow
---@field AddLight fun(): Light

---@class Instance
---@field entity Entity
---@field components Components
---@field DynamicShadow DynamicShadow
---@field AnimState AnimState
---@field AddTag fun(self: Instance, name: string)
---@field AddComponent fun(self: Instance, name: string)
---@field ListenForEvent fun(self: Instance, event_name: string, callback: fun(inst: table<any, any>, data: table<any, any>), source: Instance?)
---@field PushEvent fun(self: Instance, event_name: string, data: table<any, any>?)
---@field RemoveEventCallback fun(self: Instance, event_name: string, callback: fun(inst: table<any, any>, data: table<any, any>), source: Instance?)
---@field OnSave fun(inst: Instance, data: table<any, any>)

---@class Component
---@field inst Instance
---@field GoalCompletionListener EventCallback?

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

---@class Clock: Component
---@field Reset fun(self: Clock)
---@field IsNight fun(self: Clock): boolean
---@field inst Instance

---@class Map
---@field GetTileAtPoint fun(self: Map, x: number, y: number, z: number): string

---@class Transform
---@field GetWorldPosition fun(self: Transform): number, number, number
---@field SetPosition fun(self: Transform, x: number, y: number, z: number)

---@class LightWatcher
---@field GetLightValue fun(self: LightWatcher): number
---@field IsInLight fun(self: LightWatcher): boolean

---@class WorldComponents
---@field seasonmanager SeasonManager

---@class SeasonManager: Component
---@field GetSeasonString fun(self: SeasonManager): string
---@field preciptype string
---@field precip boolean | nil

---@class Components
---@field aura Aura
---@field inspectable Inspectable
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

---@class Inspectable: Component
---@field getstatus function

---@class Aura: Component
---@field radius number
---@field tickperiod number
---@field ignoreallies boolean
---@field auratestfn function

---@class Light: Component
---@field SetIntensity fun(self: Light, intensity: number)
---@field SetRadius fun(self: Light, radius: number)
---@field SetFalloff fun(self: Light, falloff: number)
---@field Enable fun(self: Light, state: boolean)
---@field SetColour fun(self: Light, r: number, g: number, b: number)

---@class DynamicShadow: Component
---@field SetSize fun(self, height: number, width: number)

---@class AnimState: Component
---@field PlayAnimation fun(self: AnimState, name: string, loop: boolean?)
---@field SetBank fun(self: AnimState, name: string)
---@field SetBuild fun(self: AnimState, name: string)
---@field SetBloomEffectHandle fun(self: AnimState, name: string)

---@class Inventory: Component
---@field itemslots ItemSlot[]
---@field equipslots InventoryEquipSlots
---@field Equip fun(self: Inventory, item: ItemSlot)
---@field FindItem fun(self: Inventory, fn: fun(item: ItemSlot): boolean): ItemSlot|nil
---@field RemoveItem fun(self: Inventory, item: ItemSlot): ItemSlot
---@field GiveItem fun(self: Inventory, item: ItemSlot)

---@class Locomotor: Component
---@field walkspeed number
---@field runspeed number
---@field PushAction fun(self: Locomotor, action: BufferedAction, force?: boolean)
---@field GoToPoint fun(self: Locomotor, position: Vector3, action?: BufferedAction, run?: boolean)
---@field RunInDirection fun(self: Locomotor, direction: Vector3, throttle: number?)
---@field Stop fun(self: Locomotor)

---@class Combat: Component
---@field target Entity?
---@field defaultdamage integer
---@field playerdamagepercent number
---@field SetRetargetFunction fun(self: Component, cooldown: number, retarget_fn: fun(inst: Instance))
---@field SetTarget fun(self: Combat, target: Entity)
---@field IsValidTarget fun(self: Combat, target: Entity): boolean

---@class Builder: Component
---@field CanBuild fun(self: Builder, recipe_name: string): boolean
---@field DoBuild fun(self: Builder, recipe_name: string, point?: Vector3, rotation?: number): boolean, string
---@field KnowsRecipe fun(self: Builder, recipe_name: string): boolean

---@class Health: Component
---@field GetPercent fun(self: Health): number
---@field IsHurt fun(self: Health): boolean
---@field SetMaxHealth fun(self: Health, health: integer)
---@field StartRegen fun(self: Health, amount: integer, period: number)

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

---@class LootDropper: Component
---@field DropLoot fun(self: LootDropper, point: Vector3?)

---@class FireFX: Component
---@field percent number
---@field level integer

---@class ItemSlot
---@field name string
---@field prefab string
---@field components ItemSlotComponents

---@class ItemSlotComponents
---@field stackable ItemStackableComponent
---@field edible ItemEdibleComponent
---@field perishable ItemPerishableComponent
---@field cookable ItemCookableComponent?

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

---@class ItemCookableComponent
---@field product string
---@field Cook function

---@class BufferedAction
---@field AddSuccessAction fun(self: BufferedAction, callback: function)
---@field AddFailAction fun(self: BufferedAction, callback: function)

---@class Recipe
---@field name string

---@class InventoryEquipSlots
---@field hands ItemSlot|nil

---@class Asset

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

---@param inst Entity
---@param radius integer?
---@param fn fun(entity: Entity): boolean?
---@param musttags string[]?
---@param canttags string[]?
---@param mustoneoftags string[]?
---@diagnostic disable-next-line: unused-local
function FindEntity(inst, radius, fn, musttags, canttags, mustoneoftags) end

---@return Player
---@diagnostic disable-next-line: unused-local, missing-return
function GetPlayer() end

---@param name string
---@param fn function
---@param assets table<string, any>
---@param deps table<string, any>?
---@diagnostic disable-next-line: unused-local
function Prefab(name, fn, assets, deps) end

---@param type string
---@param file string
---@param param any?
---@return Asset
---@diagnostic disable-next-line: unused-local, missing-return
function Asset(type, file, param) end

---@return Instance
---@diagnostic disable-next-line: unused-local, missing-return
function CreateEntity() end

---@param inst Instance
---@param mass number
---@param radius number
---@diagnostic disable-next-line: unused-local
function MakeGhostPhysics(inst, mass, radius) end

--- Creates a handler that runs when any Entity is created
---@param handler fun(inst: Entity)
---@diagnostic disable-next-line: unused-local
function AddPrefabPostInitAny(handler) end

--- Runs a `.lua` file (used in place of `import`)
---@param path string Relative path to the `.lua` file
---@diagnostic disable-next-line: unused-local
function modimport(path) end

--- Apparently *not* supposed to be used by modders, but fuck you it works
---@param optionname string
---@param modname string
---@return unknown|nil
---@diagnostic disable-next-line: unused-local
function GetModConfigData(optionname, modname) end
