--================================================--
--   _  ___ _    ____      _    ___   __  ____    --
--  | |/ (_) |_ / ___|__ _| |_ / _ \ / /_|___ \   --
--  | ' /| | __| |   / _` | __| (_) | '_ \ __) |  --
--  | . \| | |_| |__| (_| | |_ \__, | (_) / __/   --
--  |_|\_\_|\__|\____\__,_|\__|  /_/ \___/_____|  --
--                                                --
--================================================--

--v1.0

---The Class that represents Classes.
---@class Class:Object
---@field super Class?
---
---@field new fun(self:self, name:string, super:Class?):Class
local Class = setmetatable({__type="Class"},{__type="Class"})

function Class:new(...)
  local instance = setmetatable({}, self)
  self.constructor(instance, ...)
  return instance
end

function Class:__index(index)
  if index == "new" then return Class.new end
  local super = rawget(self, "super")
  return rawget(self, index) or super and super[index]
end
function Class:__newindex(index, value)
  if index == "new" then error('The "new" method cannot be overridden.', 2) end
  rawset(self, index, value)
end

local Object

---@protected
function Class:constructor(name, super)
  self.__type=name
  self.super=super or Object
  function self.__index(_, index)
    if index == "super" then error('Instances of classes cannot access the "super" field.', 2) end
    local s = rawget(self, "super")
    return rawget(self, index) or s and s[index]
  end
end

---The Class that every Class inherits from. 
---@class Object
---
---@field new fun():Object
Object = Class:new('Object')
function Object:constructor() end
---@param class Class
---@return boolean
function Object:instanceof(class)
  local c=getmetatable(self)
  while c do
    if c == class then return true end
    c = c.super
  end
  return false
end


local api = {}
api.Class = Class
api.Object=Object
return api
