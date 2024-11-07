require('prototypes.linked-belt')
require('prototypes.fast-linked-belt')
require('prototypes.express-linked-belt')


--	local tabl = {}

--	for item_name, item in pairs (data.raw.item) do
--		if item.subgroup then
--			if not tabl[item.subgroup] then tabl[item.subgroup] = {} end
--			table.insert (tabl[item.subgroup], item.order)
--		end
--	end


--	log (serpent.block (tabl))


local subgroup_and_order = {
  belt = {
    "a[transport-belt]-a[transport-belt]",
    "a[transport-belt]-b[fast-transport-belt]",
    "a[transport-belt]-c[express-transport-belt]",
    "b[underground-belt]-a[underground-belt]",
    "b[underground-belt]-b[fast-underground-belt]",
    "b[underground-belt]-c[express-underground-belt]",
    "c[splitter]-a[splitter]",
    "c[splitter]-b[fast-splitter]",
    "c[splitter]-c[express-splitter]",
    "d[loader]-a[basic-loader]",
    "d[loader]-b[fast-loader]",
    "d[loader]-c[express-loader]"
  },
  ["circuit-network"] = {
    "a[light]-a[small-lamp]",
    "b[wires]-a[red-wire]",
    "b[wires]-b[green-wire]",
    "c[combinators]-a[arithmetic-combinator]",
    "c[combinators]-b[decider-combinator]",
    "c[combinators]-c[constant-combinator]",
    "d[other]-a[power-switch]",
    "d[other]-b[programmable-speaker]",
    "z-z-a",
    "z-z-b"
  },
  ["defensive-structure"] = {
    "d[radar]-a[radar]",
    "a[stone-wall]-a[stone-wall]",
    "a[wall]-b[gate]",
    "z[not-used]",
    "b[turret]-a[gun-turret]",
    "b[turret]-b[laser-turret]",
    "b[turret]-c[flamethrower-turret]",
    "b[turret]-d[artillery-turret]-a[turret]",
    "a[stone-wall]-b[concrete-wall]",
    "a[stone-wall]-c[steel-wall]"
  },
  energy = {
    "b[steam-power]-a[boiler]",
    "b[steam-power]-b[steam-engine]",
    "d[solar-panel]-a[solar-panel]",
    "e[accumulator]-a[accumulator]",
    "f[nuclear-energy]-a[reactor]",
    "f[nuclear-energy]-c[heat-exchanger]",
    "f[nuclear-energy]-d[steam-turbine]",
    "f[nuclear-energy]-b[heat-pipe]",
    "a-a"
  },
  ["energy-pipe-distribution"] = {
    "a[pipe]-a[pipe]",
    "a[energy]-a[small-electric-pole]",
    "a[pipe]-b[pipe-to-ground]",
    "a[energy]-c[big-electric-pole]",
    "a[energy]-b[medium-electric-pole]",
    "a[energy]-d[substation]",
    "b[pipe]-c[pump]",
    "a[energy]-a[small-electric-pole]"
  },
  equipment = {
    "a[energy-source]-a[solar-panel]",
    "a[energy-source]-b[fusion-reactor]",
    "b[battery]-a[battery-equipment]",
    "b[battery]-b[battery-equipment-mk2]",
    "c[belt-immunity]-a[belt-immunity]",
    "d[exoskeleton]-a[exoskeleton-equipment]",
    "e[robotics]-a[personal-roboport-equipment]",
    "e[robotics]-b[personal-roboport-mk2-equipment]",
    "f[night-vision]-a[night-vision-equipment]",
    "g[heli-remote]-a[heli-remote-item]",
    "b[battery]-a[battery-equipment]",
    "b[battery]-a[battery-equipment]",
    "b[battery]-a[battery-equipment]",
    "b[battery]-a[battery-equipment]"
  },
  ["extraction-machine"] = {
    "a[items]-a[burner-mining-drill]",
    "a[items]-b[electric-mining-drill]",
    "b[fluids]-a[offshore-pump]",
    "b[fluids]-b[pumpjack]",
    "a[items]-b[electric-mining-drill]-b"
  },
  ["fuel-processing"] = {
    "m[rocket-fuel]-b[processed-fuel]"
  },
  gun = {
    "f[land-mine]"
  },
  inserter = {
    "a[burner-inserter]",
    "b[inserter]",
    "d[fast-inserter]",
    "e[filter-inserter]",
    "c[long-handed-inserter]",
    "f[stack-inserter]",
    "g[stack-filter-inserter]"
  },
  ["intermediate-product"] = {
    "a[copper-cable]",
    "b[iron-stick]",
    "c[iron-gear-wheel]",
    "e[electronic-circuit]",
    "h[engine-unit]",
    "p[rocket-fuel]",
    "f[advanced-circuit]",
    "g[processing-unit]",
    "d[empty-barrel]",
    "i[electric-engine-unit]",
    "l[flying-robot-frame]",
    "o[low-density-structure]",
    "q[uranium-rocket-fuel]",
    "n[rocket-control-unit]",
    "q[rocket-part]",
    "r[uranium-235]",
    "r[uranium-238]",
    "r[uranium-processing]-a[uranium-fuel-cell]",
    "r[used-up-uranium-fuel-cell]",
    "g[engine-unit]-a[motor]",
    "g[engine-unit]-b[electric-motor]"
  },
  ["logistic-network"] = {
    "a[robot]-a[logistic-robot]",
    "a[robot]-b[construction-robot]",
    "b[storage]-c[logistic-chest-passive-provider]",
    "b[storage]-c[logistic-chest-active-provider]",
    "b[storage]-c[logistic-chest-storage]",
    "b[storage]-d[logistic-chest-buffer]",
    "b[storage]-e[logistic-chest-requester]",
    "c[signal]-a[roboport]"
  },
  ["military-equipment"] = {
    "a[shield]-a[energy-shield-equipment]",
    "a[shield]-b[energy-shield-equipment-mk2]",
    "b[active-defense]-a[personal-laser-defense-equipment]",
    "b[active-defense]-b[discharge-defense-equipment]-a[equipment]"
  },
  module = {
    "a[beacon]"
  },
  other = {
    "a[electric-energy-interface]-b[electric-energy-interface]",
    "b[heat-interface]",
    "s[simple-entity-with-force]-f[simple-entity-with-force]",
    "s[simple-entity-with-owner]-o[simple-entity-with-owner]",
    "c[item]-o[infinity-chest]",
    "d[item]-o[infinity-pipe]",
    "t[item]-o[burner-generator]",
    "a[items]-a[linked-chest]",
    "b[items]-b[linked-belt]"
  },
  ["production-machine"] = {
    "a[assembling-machine-1]-b",
    "b[assembling-machine-2]",
    "g[lab]",
    "c[assembling-machine-3]",
    "d[refinery]",
    "e[chemical-plant]",
    "g[centrifuge]",
    "g[lab]",
    "a[assembling-machine-1]-a"
  },
  ["raw-material"] = {
    "b[iron-plate]",
    "c[copper-plate]",
    "d[steel-plate]",
    "c[solid-fuel]",
    "g[sulfur]",
    "f[plastic-bar]",
    "j[explosives]",
    "h[battery]",
    "a[wood]-b-b",
    "a[wood]-b-c",
    "a[wood]-b[stone-tablet]"
  },
  ["raw-resource"] = {
    "a[wood]",
    "b[coal]",
    "d[stone]",
    "e[iron-ore]",
    "f[copper-ore]",
    "g[uranium-ore]"
  },
  ["science-pack"] = {
    "y"
  },
  ["smelting-machine"] = {
    "a[stone-furnace]",
    "c[electric-furnace]",
    "b[steel-furnace]",
    "z",
    "c[electric-furnace]-b"
  },
  ["space-related"] = {
    "e[rocket-silo]",
    "m[satellite]"
  },
  storage = {
    "a[items]-a[wooden-chest]",
    "a[items]-b[iron-chest]",
    "a[items]-c[steel-chest]",
    "b[fluid]-a[storage-tank]"
  },
  terrain = {
    "a[stone-brick]",
    "b[concrete]-a[plain]",
    "b[concrete]-c[refined]",
    "b[concrete]-b[hazard]",
    "b[concrete]-d[refined-hazard]",
    "c[landfill]-a[dirt]"
  },
  ["train-transport"] = {
    "a[train-system]-c[train-stop]",
    "a[train-system]-d[rail-signal]",
    "a[train-system]-e[rail-signal-chain]"
  },
  transport = {
    "b[personal-transport]-d[heli-pad-item]"
  }
}
