data:extend({
    {
        type = "bool-setting",
        name = "lb-linked-belts-setting-force-compatibility",
        setting_type = "startup",
        default_value = false,
        localised_name = {"mod-setting-name.force-compatibility"},
        localised_description = {"mod-setting-description.force-compatibility-description"},
    },
    {
        type = "int-setting",
        name = "lb-max-distance",
        setting_type = "runtime-global",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 1000000,
        order = "b",
    },
    {
        type = "bool-setting",
        name = "lb-same-surface-only",
        setting_type = "runtime-global",
        default_value = false,
        order = "c",
    }
})