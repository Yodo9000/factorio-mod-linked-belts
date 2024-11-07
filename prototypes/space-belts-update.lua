local name = "space-linked-belt"
local belt = "space-transport-belt"
local mod_name = "__LinkedBelts__"
local icon = mod_name.."/graphics/icons/"..name..".png"
local filename = mod_name.."/graphics/entity/"..name.."/"..name.."-structure.png"
local hr_filename = mod_name.."/graphics/entity/"..name.."/hr-"..name.."-structure.png"
local letters = {}
local technologies = {}
local speeds = {}

letters["space-linked-belt"]="f"
technologies["space-linked-belt"]="se-space-platform-scaffold"
speeds["space-linked-belt"]=4*0.03125

local technology = technologies[name]
local speed = speeds[name]
local letter = letters[name]

if mods["boblogistics"] and mods["SE-Bob"] then
  ssub = "space-belts"
  sord = "d[linked-belt]-1[space-linked-belt]"
else
  ssub = "belt"
  sord = "e[linked-belt]-"..letter.."["..name.."]"
end

--space linked belt
local sitem = {
  type = "item",
  name = "space-linked-belt",
  icon = icon,
  icon_size = 64,
  icon_mipmaps = 4,
  subgroup = ssub,
  order = sord,
  place_result = "space-linked-belt",
  stack_size = 10
}

local srecipe = {
  type = "recipe",
  name = "space-linked-belt",
  ingredients = {
    {"se-space-underground-belt", 2}
  },
  result = "space-linked-belt",
  result_count = 2
}

local sentity = {
  type = "linked-belt",
  name = "space-linked-belt",
  icon = icon,
  icon_size = 64,
  icon_mipmaps = 4,
  flags = {
    "placeable-neutral",
    "player-creation"
  },
  minable = {
    mining_time = 0.1,
    result = "space-linked-belt"
  },
  max_health = 140,
  corpse = "small-remnants",
  open_sound = {
    {
      filename = "__base__/sound/machine-open.ogg",
      volume = 0.5
    }
  },
  close_sound = {
    {
      filename = "__base__/sound/machine-close.ogg",
      volume = 0.5
    }
  },
  working_sound = {
    sound = {
      filename = "__base__/sound/underground-belt.ogg",
      volume = 0.2
    },
    max_sounds_per_type = 2,
    audible_distance_modifier = 0.5,
    persistent = true,
    use_doppler_shift = false
  },
  resistances = {
    {
      type = "fire",
      percent = 60
    },
    {
      type = "impact",
      percent = 30
    }
  },
  collision_box = {
    {
      -0.4,
      -0.4
    },
    {
      0.4,
      0.4
    }
  },
  selection_box = {
    {
      -0.5,
      -0.5
    },
    {
      0.5,
      0.5
    }
  },
  damaged_trigger_effect = {
    type = "create-entity",
    entity_name = "spark-explosion",
    offset_deviation = {
      {
        -0.5,
        -0.5
      },
      {
        0.5,
        0.5
      }
    },
    offsets = {
      {
        0,
        1
      }
    },
    damage_type_filters = "fire"
  },
  animation_speed_coefficient = 32,
  belt_animation_set = {
    animation_set = {
      filename = "__space-exploration-graphics__/graphics/entity/"..belt.."/"..belt..".png",
      priority = "extra-high",
      width = 64,
      height = 64,
      frame_count = 16,
      direction_count = 20,
      hr_version = {
        filename = "__space-exploration-graphics__/graphics/entity/"..belt.."/hr-"..belt..".png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 16,
        direction_count = 20
      }
    }
  },
  fast_replaceable_group = nil,
  speed = 4*0.03125,
  structure_render_layer = "object",
  structure = {
    direction_in = {
      sheet = {
        filename = filename,
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 96,
        hr_version = {
          filename = hr_filename,
          priority = "extra-high",
          width = 192,
          height = 192,
          y = 192,
          scale = 0.5
        }
      }
    },
    direction_out = {
      sheet = {
        filename = filename,
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = hr_filename,
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    direction_in_side_loading = {
      sheet = {
        filename = filename,
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 288,
        hr_version = {
          filename = hr_filename,
          priority = "extra-high",
          width = 192,
          height = 192,
          y = 576,
          scale = 0.5
        }
      }
    },
    direction_out_side_loading = {
      sheet = {
        filename = filename,
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 192,
        hr_version = {
          filename = hr_filename,
          priority = "extra-high",
          width = 192,
          height = 192,
          y = 384,
          scale = 0.5
        }
      }
    },
    back_patch = {
      sheet = {
        filename = "__base__/graphics/entity/express-underground-belt/express-underground-belt-structure-back-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/express-underground-belt/hr-express-underground-belt-structure-back-patch.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    front_patch = {
      sheet = {
        filename = "__base__/graphics/entity/express-underground-belt/express-underground-belt-structure-front-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/express-underground-belt/hr-express-underground-belt-structure-front-patch.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    }
  },
  allow_clone_connection = true,
  allow_blueprint_connection = true,
  allow_side_loading = false
}

data:extend({sitem, srecipe, sentity})

if mods["boblogistics"] and settings.startup["bobmods-logistics-beltoverhaulspeed"].value == true then
  if settings.startup["bobmods-logistics-beltoverhaul"].value == true then 
    bobmods.logistics.set_belt_speed("linked-belt", "space-linked-belt", 4)
  else
    bobmods.logistics.set_belt_speed("linked-belt", "space-linked-belt", 3)
  end
end
