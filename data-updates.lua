local byte_0 = string.byte("a")-1
local tint = {0.65, 0.65, 0.65} -- to recolor the items and entities
local speeds_names = {} -- to not make multiple with the same speed, store the name so that it can be iterated over later
local speeds = {} -- store all the speeds so that they can be sorted (keys cannot be sorted in lua)

for _, prototype in pairs(data.raw["underground-belt"]) do
  if not speeds_names[prototype.speed] then
    table.insert(speeds, prototype.speed)
    local prototype_copy = util.table.deepcopy(prototype)

    prototype_copy.type = "linked-belt"
    prototype_copy.name = "linked-"..prototype.name
    speeds_names[prototype.speed] = prototype_copy.name

    prototype_copy.hidden_in_factoriopedia = true -- I'm not sure if this works. Need to change description etc if visible in Factoriopedia
    prototype_copy.minable.result = prototype_copy.name
    prototype_copy.fast_replaceable_group = "linked-belt"
    prototype_copy.localised_name = {"entity-name.linked-belts", {"entity-name."..prototype.name}} -- has extra capitalisation

    if prototype.next_upgrade then
      prototype_copy.next_upgrade = "linked-"..prototype.next_upgrade -- can cause a loading error if this entity is not added due to matching speed
    end

    for _, sprite_4_way in pairs(prototype_copy.structure) do -- sprites can be defined in three different ways
      if sprite_4_way.sheets then
        for _, sheet in pairs(sprite_4_way.sheets) do
          sheet.tint = tint
        end
      end
      for _, property in pairs({"sheet", "north", "east", "south", "west"}) do
        if sprite_4_way[property] then
          sprite_4_way[property].tint = tint
        end
      end
    end
    -- need to tint entity icon for upgrade planners:
    if prototype.icons then
      for _, icon in pairs(prototype_copy.icons) do
        icon.tint = tint
      end
    else
      prototype_copy.icons = {{icon=prototype.icon, tint=tint, icon_size=prototype.icon_size}}
      prototype_copy.icon = nil
    end

    local item = {
      type = "item",
      name = prototype_copy.name,
      --icon_size = 64,
      icons = prototype_copy.icons,
      subgroup = data.raw.item[prototype.name].subgroup or prototype_copy.subgroup or "belt",
      --order is set later (some mods add the belts in a weird order, so sorting is needed)
      place_result = prototype_copy.name,
      stack_size = 10,
    }

    local recipe = { -- doesn't display properly in-game? also need to add unlock
      type = "recipe",
      name = prototype_copy.name,
      enabled = false, -- is_enabled_at_game_start is a more descriptive name
      ingredients = {{type="item", name=prototype.name, amount=2}},
      results     = {{type="item", name=prototype_copy.name, amount=2}}
    }

    data:extend{prototype_copy, item, recipe}

    -- Add recipe unlock to the correct technology:
    for _, technology in pairs(data.raw.technology) do
      for _, modifier in pairs(technology.effects or {}) do -- some technologies don't have effects
        if modifier.type == "unlock-recipe" then
          if modifier.recipe == prototype.name then -- doesn't work if the original recipe has a different name
            table.insert(technology.effects, {type = "unlock-recipe", recipe = prototype_copy.name})
            break
          end
        end
      end
    end
  end
end

table.sort(speeds)
local _, prev_speed = next(speeds)-- to store the speed of the entity that needs to be upgraded
for i, speed in pairs(speeds) do
  data.raw.item[speeds_names[speed]].order = "l"..string.char(i + byte_0) -- convert uint to letter in alphabetic order
  --data.raw["linked-belt"][speeds_names[prev_speed]].next_upgrade = speeds_names[speed] -- can avert loading errors due to belts with matching speeds, but this can cause migration problems (i.e. the mod loading order changes and which belt is skipped changes). I could have avoided the migration problems if the linked belt entities had names based only on their speed, but doing this now requires a lua migration.
  prev_speed = speed
end