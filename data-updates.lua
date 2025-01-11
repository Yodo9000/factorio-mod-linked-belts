local byte_0 = string.byte("a")-1
local tint = {0.65, 0.65, 0.65} -- to recolor the items and entities
local speeds = {} -- to not make multiple with the same speed, store as a set

for _, prototype in pairs(data.raw["underground-belt"]) do
  if not speeds[prototype.speed] then -- can cause crashes if two other mods define ug belts with the same speed, but I think a crash is better than deleting entities
    speeds[prototype.speed] = true
    local prototype_copy = util.table.deepcopy(prototype)
    prototype_copy.type = "linked-belt"
    prototype_copy.name = "linked-"..prototype.name
    prototype_copy.hidden_in_factoriopedia = true -- I'm not sure if this works. Need to change description etc if visible in Factoriopedia
    prototype_copy.minable.result = prototype_copy.name
    prototype_copy.fast_replaceable_group = "linked-belt"
    if prototype.next_upgrade then
      prototype_copy.next_upgrade = "linked-"..prototype.next_upgrade -- doesn't replace other side of the link though
    end
    prototype_copy.localised_name = {"entity-name.linked-belts", {"entity-name."..prototype.name}} -- has extra capitalisation
    for _, sprite_4_way in pairs(prototype_copy.structure) do -- should maybe be a bit more general to deal with differently defined sprites
      sprite_4_way.sheet.tint = tint
    end
    -- need to tint entity icon for upgrade planners:
    if prototype.icons then
      for _, icon in pairs(prototype_copy.icons) do
        icon.tint = tint
      end
    else
      prototype_copy.icons = {{icon=prototype.icon, tint=tint}}
      prototype_copy.icon = nil
    end

    local item = {
      type = "item",
      name = prototype_copy.name,
      icon_size = 64,
      icons = prototype_copy.icons,
      subgroup = data.raw.item[prototype.name].subgroup or prototype_copy.subgroup or "belt",
      order = "e"..string.char(table_size(speeds) + byte_0), -- convert uint to letter in alphabetic order
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
