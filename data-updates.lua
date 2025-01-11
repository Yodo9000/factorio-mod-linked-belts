local tint = {0.65, 0.65, 0.65} -- to recolor the items and entities
local speeds = {} -- to not make multiple with the same speed, store as a set

for _, prototype in pairs(data.raw["underground-belt"]) do
  if not speeds[prototype.speed] then
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
    end

    local item = {
      type = "item",
      name = prototype_copy.name,
      icon_size = 64,
      icon_mipmaps = 4,
      icons = prototype_copy.icons,
      subgroup = "belt",
      order = "e"..string.sub(data.raw["item"][prototype.name].order, 2, -1), -- get order from original, and replace b with e -- error, access nil
      place_result = prototype_copy.name,
      stack_size = 10,
    }

    local recipe = { -- doesn't display properly in-game? also need to add unlock
      type = "recipe",
      name = prototype_copy.name,
      --subgroup = "belt",
      enabled = false, -- is_enabled_at_game_start is a more descriptive name
      ingredients = {{type="item", name=prototype.name, amount=2}},
      results     = {{type="item", name=prototype_copy.name, amount=2}}
    }

    data:extend{prototype_copy, item, recipe}

    -- Add recipe unlock to the correct technology:
    for _, technology in pairs(data.raw["technology"]) do
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
