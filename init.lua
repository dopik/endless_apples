
-- alternative apple
minetest.register_node("endless_apples:apple", {
	description = "Apple",
	drawtype = "plantlike",
	tiles = {"default_apple.png"},
	inventory_image = "default_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, food_apple = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),
})

-- override default apple
minetest.register_node(":default:apple", {
	description = "Apple",
	drawtype = "plantlike",
	tiles = {"default_apple.png"},
	inventory_image = "default_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, food_apple = 1,
		not_in_creative_inventory = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local nodes = minetest.find_nodes_in_area({x = pos.x -2, y = pos.y -2, z = pos.z -2}, {x = pos.x +2, y = pos.y +2, z = pos.z +2}, "group:leaves")
		local c = 0
		for k, nodepos in pairs(nodes) do
			if minetest.get_node(nodepos).param2 == 0 then
				c = c +1
			end
		end
		
		if c < 10 then -- only make apple regrowable if at least 10 non user-placed leaves are around
			return
		end
		
		minetest.set_node(pos, {name = "endless_apples:apple_mark", param2 = 1})
		minetest.get_node_timer(pos):start(math.random(120, 300))
	end,
	drop = "endless_apples:apple"
})

-- air node to mark apple pos
minetest.register_node("endless_apples:apple_mark", {
	description = "Air!",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	groups = {not_in_creative_inventory = 1},
	on_timer = function(pos, elapsed)
		if minetest.get_node(pos).param1 < 12 then -- enough light to grow apples?
			minetest.get_node_timer(pos):start(math.random(40, 75)) -- no: try again in 40-75 seconds
			return
		end
		minetest.set_node(pos, {name = "default:apple"})
	end
})
