-- generates one linked belt for every distinct underground belt speed

local force_compatibility = settings.startup["lb-linked-belts-setting-force-compatibility"].value

local byte_prefix = "l" -- item order prefix, keeps linked belts together in the belt subgroup
local tint = {0.7, 0.7, 0.7, 1} -- recolors items and entities, alpha included for multiplication

for i, key in ipairs({"r", "g", "b", "a"}) do -- otherwise errors when multiplying 'rgba' tints with '1234' tints
  tint[key] = tint[i]
end

-- multiply the values of the first table with the corresponding values of the second one, in place
local function multiply_table(table1, table2)
  if not table1 then
    return nil
  end
  for i, value in pairs(table1) do
    if table2[i] then
      table1[i] = value * table2[i]
    end
  end
  return table1
end

-- the item that places this underground belt; the name is not always equal to the entity name
local function get_source_item(prototype)
  local candidates = {}
  local minable = prototype.minable
  if minable then
    if minable.result then
      table.insert(candidates, minable.result)
    end
    if minable.results then
      for _, result in pairs(minable.results) do
        local name = result.name or result[1]
        if name then
          table.insert(candidates, name)
        end
      end
    end
  end
  table.insert(candidates, prototype.name)
  for _, name in ipairs(candidates) do
    if data.raw.item[name] then
      return data.raw.item[name]
    end
  end
  for _, item in pairs(data.raw.item) do
    if item.place_result == prototype.name then
      return item
    end
  end
  return nil
end

-- every recipe that produces the given item, so that renamed recipes are still found
local function get_recipe_names(item_name)
  local names = {}
  for _, recipe in pairs(data.raw.recipe) do
    if recipe.results then
      for _, result in pairs(recipe.results) do
        if (result.name or result[1]) == item_name then
          names[recipe.name] = true
          break
        end
      end
    end
  end
  return names
end

-- unlock the linked recipe wherever the original recipe is unlocked
local function copy_recipe_unlocks(source_recipes, linked_recipe_name)
  for _, technology in pairs(data.raw.technology) do
    local found = false
    for _, modifier in pairs(technology.effects or {}) do
      if modifier.type == "unlock-recipe" and source_recipes[modifier.recipe] then
        found = true
        break
      end
    end
    if found then
      table.insert(technology.effects, {type = "unlock-recipe", recipe = linked_recipe_name})
    end
  end
end

-- pairs() order is not stable, sort so that the same belt is picked on every load
local underground_names = {}
for name in pairs(data.raw["underground-belt"]) do
  table.insert(underground_names, name)
end
table.sort(underground_names)

local speeds = {} -- sortable list of all handled speeds
local speeds_names = {} -- speed -> linked belt name, only one linked belt per speed

for _, underground_name in ipairs(underground_names) do
  local prototype = data.raw["underground-belt"][underground_name]
  local item = get_source_item(prototype)

  if not item then
    log("LinkedBelts: no item found for underground belt '" .. underground_name .. "', skipping it")
  elseif not speeds_names[prototype.speed] then
    table.insert(speeds, prototype.speed)
    local prototype_copy = util.table.deepcopy(prototype)

    prototype_copy.type = "linked-belt"
    prototype_copy.name = "linked-" .. prototype.name
    prototype_copy.linked_belts_source = prototype.name -- extra properties are ignored by the game
    speeds_names[prototype.speed] = prototype_copy.name

    prototype_copy.hidden_in_factoriopedia = true
    prototype_copy.fast_replaceable_group = "linked-belt"
    prototype_copy.next_upgrade = nil -- resolved in a second pass, the target may not exist yet
    prototype_copy.localised_name = {"entity-name.linked-belts", {"entity-name." .. prototype.name}}
    prototype_copy.minable = prototype_copy.minable or {mining_time = 0.1}
    prototype_copy.minable.result = prototype_copy.name
    prototype_copy.minable.results = nil
    prototype_copy.minable.count = nil

    for _, sprite_4_way in pairs(prototype_copy.structure or {}) do -- sprites can be defined in three different ways
      if type(sprite_4_way) == "table" then
        if sprite_4_way.sheets then
          for _, sheet in pairs(sprite_4_way.sheets) do
            sheet.tint = multiply_table(sheet.tint, tint) or tint
          end
        end
        for _, property in pairs({"sheet", "north", "east", "south", "west"}) do
          if sprite_4_way[property] then
            sprite_4_way[property].tint = multiply_table(sprite_4_way[property].tint, tint) or tint
          end
        end
      end
    end

    -- the entity icon has to be tinted too, it is used by upgrade planners
    if prototype_copy.icons then
      for _, icon in pairs(prototype_copy.icons) do
        icon.tint = multiply_table(icon.tint, tint) or tint
      end
    elseif prototype.icon then
      prototype_copy.icons = {{icon = prototype.icon, tint = tint, icon_size = prototype.icon_size}}
      prototype_copy.icon = nil
    else
      prototype_copy.icons = util.table.deepcopy(item.icons)
        or {{icon = item.icon, tint = tint, icon_size = item.icon_size}}
    end

    local linked_item = {
      type = "item",
      name = prototype_copy.name,
      icons = util.table.deepcopy(prototype_copy.icons),
      subgroup = item.subgroup or prototype_copy.subgroup or "belt",
      -- order is set later, some mods add the belts in a weird order
      place_result = prototype_copy.name,
      stack_size = item.stack_size or 10,
    }

    local linked_recipe = {
      type = "recipe",
      name = prototype_copy.name,
      enabled = false,
      ingredients = {{type = "item", name = item.name, amount = 2}},
      results = {{type = "item", name = prototype_copy.name, amount = 2}},
    }

    data:extend{prototype_copy, linked_item, linked_recipe}

    copy_recipe_unlocks(get_recipe_names(item.name), linked_recipe.name)
  end
end

-- second pass: resolve upgrade targets only to linked belts that really exist.
-- a skipped underground belt maps to the linked belt of the same speed, so no
-- reference can dangle and no loading error is produced.
for _, underground_name in ipairs(underground_names) do
  local prototype = data.raw["underground-belt"][underground_name]
  local linked_name = speeds_names[prototype.speed]
  local linked = linked_name and data.raw["linked-belt"][linked_name]
  if linked and prototype.next_upgrade then
    local next_underground = data.raw["underground-belt"][prototype.next_upgrade]
    local target_name = next_underground and speeds_names[next_underground.speed]
    local target = target_name and data.raw["linked-belt"][target_name]
    -- only upgrade upwards, this rules out self references and cycles
    if target and target_name ~= linked_name and target.speed > linked.speed then
      linked.next_upgrade = target_name
    end
  end
end

table.sort(speeds)
for i, speed in ipairs(speeds) do
  local name = speeds_names[speed]
  data.raw.item[name].order = byte_prefix .. string.format("%03d", i)
  if force_compatibility then
    -- ignore the upgrade targets of the original belts and build one plain chain instead
    data.raw["linked-belt"][name].next_upgrade = speeds_names[speeds[i + 1]]
  end
end
