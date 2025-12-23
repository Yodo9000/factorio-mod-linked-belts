local belt_tiers = {
    "underground-belt",
    "fast-underground-belt",
    "express-underground-belt",
    "turbo-underground-belt",
}

data:extend({
    {
        type = "bool-setting",
        name = "lb-linked-belts-same-surface",
        localised_name = {"mod-setting-name.linked-belts-same-surface"},
        localised_description = {"mod-setting-description.linked-belts-same-surface"},
        setting_type = "runtime-global",
        default_value = true,
    }
})

for i, belt_tier in ipairs(belt_tiers) do
    data:extend({
        {
            type = "int-setting",
            name = "lb-linked-"..belt_tier.."-range",
            localised_name = {"mod-setting-name.linked-belts-range", {"entity-name."..belt_tier}},
            localised_description = {"mod-setting-description.linked-belts-range", {"entity-name."..belt_tier}},
            setting_type = "runtime-global",
            default_value = 0,
            minimum_value = 0,
            maximum_value = 86400,
            order = "a"..i
        },
    })
end