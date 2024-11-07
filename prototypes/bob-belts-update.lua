function bobmods.logistics.belt_speed(level)
  return level * settings.startup["bobmods-logistics-beltspeedperlevel"].value / 480
end

function bobmods.logistics.set_belt_speed(type, belt, level)
  if data.raw[type][belt] then
    data.raw[type][belt].speed = bobmods.logistics.belt_speed(level)
  end
end

if settings.startup["bobmods-logistics-beltoverhaul"].value == true then
--basic linked belt
local bitem = {
  type = "item",
  name = "basic-linked-belt",
  icon = "__LinkedBelts__/graphics/icons/black-linked-belt.png",
  icon_size = 32,
  icon_mipmaps = 4,
  subgroup = "bob-logistic-tier-0",
  order = "d[linked-belt]-1[basic-linked-belt]",
  place_result = "basic-linked-belt",
  stack_size = 10
}

local brecipe = {
  type = "recipe",
  name = "basic-linked-belt",
  ingredients = {
    {"basic-underground-belt", 2}
  },
  result = "basic-linked-belt",
  result_count = 2
}

local bentity = {
  type = "linked-belt",
  name = "basic-linked-belt",
  icon = "__LinkedBelts__/graphics/icons/black-linked-belt.png",
  icon_size = 32,
  icon_mipmaps = 4,
  flags = {
    "placeable-neutral",
    "player-creation"
  },
  minable = {
    mining_time = 0.1,
    result = "basic-linked-belt"
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
      filename = "__boblogistics__/graphics/entity/transport-belt/black-transport-belt.png",
      priority = "extra-high",
      width = 64,
      height = 64,
      frame_count = 16,
      direction_count = 20,
      hr_version = {
        filename = "__boblogistics__/graphics/entity/transport-belt/hr-black-transport-belt.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 16,
        direction_count = 20
      }
    }
  },
  fast_replaceable_group = "linked-belts",
  next_upgrade = "linked-belt",
  speed = 0.5/32,
  structure_render_layer = "object",
  structure = {
    direction_in = {
      sheet = {
        filename = "__boblogistics__/graphics/entity/transport-belt/black-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 96,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-black-underground-belt-structure.png",
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
        filename = "__boblogistics__/graphics/entity/transport-belt/black-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-black-underground-belt-structure.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    direction_in_side_loading = {
      sheet = {
        filename = "__boblogistics__/graphics/entity/transport-belt/black-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 288,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-black-underground-belt-structure.png",
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
        filename = "__boblogistics__/graphics/entity/transport-belt/black-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 192,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-black-underground-belt-structure.png",
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
        filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-back-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-back-patch.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    front_patch = {
      sheet = {
        filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-front-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-front-patch.png",
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

data:extend({bitem, brecipe, bentity})
end

--turbo linked belt
local pitem = {
  type = "item",
  name = "turbo-linked-belt",
  icon = "__LinkedBelts__/graphics/icons/purple-linked-belt.png",
  icon_size = 32,
  icon_mipmaps = 4,
  subgroup = "bob-logistic-tier-4",
  order = "d[linked-belt]-d[turbo-linked-belt]",
  place_result = "turbo-linked-belt",
  stack_size = 10
}

local precipe = {
  type = "recipe",
  name = "turbo-linked-belt",
  enabled = false,
  ingredients = {
    {"turbo-underground-belt", 2}
  },
  result = "turbo-linked-belt",
  result_count = 2
}

local pentity = {
  type = "linked-belt",
  name = "turbo-linked-belt",
  icon = "__LinkedBelts__/graphics/icons/purple-linked-belt.png",
  icon_size = 32,
  icon_mipmaps = 4,
  flags = {
    "placeable-neutral",
    "player-creation"
  },
  minable = {
    mining_time = 0.1,
    result = "turbo-linked-belt"
  },
  max_health = 180,
--  corpse = "underground-belt-remnants",
  corpse = "small-remnants",
--  dying_explosion = "underground-belt-explosion",
--  dying_explosion = ubelt.."-explosion",
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
      filename = "__boblogistics__/graphics/entity/transport-belt/purple-transport-belt.png",
      priority = "extra-high",
      width = 64,
      height = 64,
      frame_count = 16,
      direction_count = 20,
      hr_version = {
        filename = "__boblogistics__/graphics/entity/transport-belt/hr-purple-transport-belt.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 16,
        direction_count = 20
      }
    }
  },
  fast_replaceable_group = "linked-belts",
  next_upgrade = "ultimate-linked-belt",
  speed = 0.125,
  structure_render_layer = "object",
  structure = {
    direction_in = {
      sheet = {
        filename = "__boblogistics__/graphics/entity/transport-belt/purple-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 96,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-purple-underground-belt-structure.png",
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
        filename = "__boblogistics__/graphics/entity/transport-belt/purple-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-purple-underground-belt-structure.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    direction_in_side_loading = {
      sheet = {
        filename = "__boblogistics__/graphics/entity/transport-belt/purple-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 288,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-purple-underground-belt-structure.png",
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
        filename = "__boblogistics__/graphics/entity/transport-belt/purple-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 192,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-purple-underground-belt-structure.png",
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
        filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-back-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-back-patch.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    front_patch = {
      sheet = {
        filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-front-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-front-patch.png",
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

data:extend({pitem, precipe, pentity})


--ultimate linked belt
local gitem = {
  type = "item",
  name = "ultimate-linked-belt",
  icon = "__LinkedBelts__/graphics/icons/green-linked-belt.png",
  icon_size = 32,
  icon_mipmaps = 4,
  subgroup = "bob-logistic-tier-5",
  order = "d[linked-belt]-e[ultimate-linked-belt]",
  place_result = "ultimate-linked-belt",
  stack_size = 10
}

local grecipe = {
  type = "recipe",
  name = "ultimate-linked-belt",
  enabled = false,
  ingredients = {
    {"ultimate-underground-belt", 2}
  },
  result = "ultimate-linked-belt",
  result_count = 2
}

local gentity = {
  type = "linked-belt",
  name = "ultimate-linked-belt",
  icon = "__LinkedBelts__/graphics/icons/green-linked-belt.png",
  icon_size = 32,
  icon_mipmaps = 4,
  flags = {
    "placeable-neutral",
    "player-creation"
  },
  minable = {
    mining_time = 0.1,
    result = "ultimate-linked-belt"
  },
  max_health = 190,
--  corpse = "underground-belt-remnants",
  corpse = "small-remnants",
--  dying_explosion = "underground-belt-explosion",
--  dying_explosion = ubelt.."-explosion",
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
      filename = "__boblogistics__/graphics/entity/transport-belt/green-transport-belt.png",
      priority = "extra-high",
      width = 64,
      height = 64,
      frame_count = 16,
      direction_count = 20,
      hr_version = {
        filename = "__boblogistics__/graphics/entity/transport-belt/hr-green-transport-belt.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 16,
        direction_count = 20
      }
    }
  },
  fast_replaceable_group = "linked-belts",
  next_upgrade = "linked-belt",
  speed = 0.15625,
  structure_render_layer = "object",
  structure = {
    direction_in = {
      sheet = {
        filename = "__boblogistics__/graphics/entity/transport-belt/green-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 96,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-green-underground-belt-structure.png",
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
        filename = "__boblogistics__/graphics/entity/transport-belt/green-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-green-underground-belt-structure.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    direction_in_side_loading = {
      sheet = {
        filename = "__boblogistics__/graphics/entity/transport-belt/green-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 288,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-green-underground-belt-structure.png",
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
        filename = "__boblogistics__/graphics/entity/transport-belt/green-underground-belt-structure.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 192,
        hr_version = {
          filename = "__boblogistics__/graphics/entity/transport-belt/hr-green-underground-belt-structure.png",
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
        filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-back-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-back-patch.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    front_patch = {
      sheet = {
        filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-front-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-front-patch.png",
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

data:extend({gitem, grecipe, gentity})


data.raw["linked-belt"]["linked-belt"].fast_replaceable_group = "linked-belts"
data.raw["linked-belt"]["linked-belt"].next_upgrade = "fast-linked-belt"
data.raw.item["linked-belt"].subgroup = "bob-logistic-tier-1"

data.raw["linked-belt"]["fast-linked-belt"].fast_replaceable_group = "linked-belts"
data.raw["linked-belt"]["fast-linked-belt"].next_upgrade = "express-linked-belt"
data.raw.item["fast-linked-belt"].subgroup = "bob-logistic-tier-2"

data.raw["linked-belt"]["express-linked-belt"].fast_replaceable_group = "linked-belts"
data.raw["linked-belt"]["express-linked-belt"].next_upgrade = "turbo-linked-belt"
data.raw.item["express-linked-belt"].subgroup = "bob-logistic-tier-3"

bobmods.lib.tech.add_recipe_unlock("logistics-4", "turbo-linked-belt")
bobmods.lib.tech.add_recipe_unlock("logistics-5", "ultimate-linked-belt")

if settings.startup["bobmods-logistics-beltoverhaulspeed"].value == true then
  if settings.startup["bobmods-logistics-beltoverhaul"].value == true then 
    bobmods.logistics.set_belt_speed("linked-belt", "basic-linked-belt", 1)

    bobmods.logistics.set_belt_speed("linked-belt", "linked-belt", 2)

    bobmods.logistics.set_belt_speed("linked-belt", "fast-linked-belt", 3)

    bobmods.logistics.set_belt_speed("linked-belt", "express-linked-belt", 4)

    bobmods.logistics.set_belt_speed("linked-belt", "turbo-linked-belt", 5)

    bobmods.logistics.set_belt_speed("linked-belt", "ultimate-linked-belt", 6)
  else
    bobmods.logistics.set_belt_speed("linked-belt", "linked-belt", 1)

    bobmods.logistics.set_belt_speed("linked-belt", "fast-linked-belt", 2)

    bobmods.logistics.set_belt_speed("linked-belt", "express-linked-belt", 3)

    bobmods.logistics.set_belt_speed("linked-belt", "turbo-linked-belt", 4)

    bobmods.logistics.set_belt_speed("linked-belt", "ultimate-linked-belt", 5)
  end
end
