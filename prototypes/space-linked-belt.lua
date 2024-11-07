local mod_name = "__LinkedBelts-Extension__"

--local name = "fast-linked-belt"
local name = "space-linked-belt"

local ingredient = "se-space-underground-belt"

local subgroup = "belt" -- only belt

local belt = "space-transport-belt"
local ubelt = "space-underground-belt"
local base_ubelt = "express-underground-belt"

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
local order = "e[linked-belt]-"..letter.."["..name.."]"

local item = {
  type = "item",
  name = name,
  icon = icon,
  icon_size = 64,
  icon_mipmaps = 4,
  subgroup = subgroup,
  order = order,
  place_result = name,
  stack_size = 10
}

local recipe = {
  type = "recipe",
  name = name,
  enabled = false,
  ingredients = {
    {ingredient, 2}
  },
  result = name,
  result_count = 2
}

table.insert (data.raw.technology[technology].effects,
		{type = "unlock-recipe", recipe = name})


local entity = {
  type = "linked-belt",
  name = name,
  icon = icon,
  icon_size = 64,
  icon_mipmaps = 4,
  flags = {
    "placeable-neutral",
    "player-creation"
  },
  minable = {
    mining_time = 0.1,
    result = name
  },
  max_health = 160,
  corpse = "underground-belt-remnants",
  dying_explosion = "underground-belt-explosion",
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
--  fast_replaceable_group = "linked-belts",
  speed = speed,
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
        filename = "__base__/graphics/entity/"..base_ubelt.."/"..base_ubelt.."-structure-back-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/"..base_ubelt.."/hr-"..base_ubelt.."-structure-back-patch.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    front_patch = {
      sheet = {
        filename = "__base__/graphics/entity/"..base_ubelt.."/"..base_ubelt.."-structure-front-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/"..base_ubelt.."/hr-"..base_ubelt.."-structure-front-patch.png",
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

data:extend({item, recipe, entity})
