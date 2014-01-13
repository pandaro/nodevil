nodevil={}
nodevil.shot_range=20
nodevil.sight_range=25

nodevil.path_find=function(pos,target,nodes)
		local best=nil
		for i,v in pairs(nodes) do 
			local near=vector.distance(v,target.pos)
			if best==nil then
				best={}
				best.pos=v
				best.dist=near
			elseif
				near<best.dist then
				best.pos=v
				best.dist=near
			end
		end
	return best
end

minetest.register_node("nodevil:stone",{
	drawtype="normal",
	tiles={"default_stone.png","default_stone.png","default_stone.png","default_stone.png","enemy.png","default_stone.png"},
	paramtype2="facedir",
	groups = {cracky=3, stone=1},
	on_punch=function(pos)
		local io=minetest.get_node((pos))
		print(dump(io))
		minetest.set_node(pos, {name="air"})
	end,
})

minetest.register_abm({
  nodenames={"nodevil:stone"},
  interval=3,
  chance=1,
	action = function(pos)
	local nodes=minetest.find_nodes_in_area({x=pos.x-1,y=pos.y-1,z=pos.z-1}, {x=pos.x+1,y=pos.y+1,z=pos.z+1},"default:stone")
	if nodes[1]==nil then return end	
	local tg=nil
	local players=minetest.get_connected_players()
	for i,v in pairs(players) do
		local player=v:getpos()
		local dist=vector.distance(pos,player)
		if tg==nil then 
			tg={}
			tg.tg=i
			tg.dist=dist
			tg.pos=player
		else
			if dist<tg.dist  then
				tg.tg=i
				tg.dist=dist
				tg.pos=player
			end
		end
	end
	if tg.dist>nodevil.sight_range then
		return
	end
	local dir =vector.direction(pos,tg.pos)
	local face=minetest.dir_to_facedir(dir,1)
	minetest.set_node(pos,{name="nodevil:stone",param2=face})
	local todir=minetest.facedir_to_dir(face)
	local bp=vector.add(pos,todir)	
	local sight=minetest.line_of_sight(bp,tg.pos,1)
	local best=nodevil.path_find(pos,tg,nodes)
	if not sight then
		minetest.after(0.5,function(param)
				minetest.remove_node(pos)
				minetest.set_node(best.pos,{name="nodevil:stone",param2=face})
		end,{pos=pos,nodes=nodes,bullett=bullett})
		return
	elseif sight then
		if best~=nil then
			dir =vector.direction(bp,tg.pos)
			local speed=vector.multiply(dir,{x=3,y=3,z=3})
			bullett=minetest.env:add_entity(bp,"nodevil:bullett")
			bullett:setvelocity(speed)			
			    minetest.sound_play("54874__lematt__balonexplose1", {
				pos = pos;
				gain = 0.3;
				max_hear_distance = 50;
			})
			minetest.after(5,function(param)
				bullett:remove()
			end,{bullett=bullett})	
			minetest.after(0.5,function(param)
				minetest.remove_node(pos)
				minetest.set_node(best.pos,{name="nodevil:stone",param2=face})
			end,{pos=pos,nodes=nodes,bullett=bullett})
		end
	end
end,
})

minetest.register_entity("nodevil:bullett",{
	hp_max = 10,
	physical = true,
	collide_with_objects = true,
	weight = 10,
	visual_size = {x=0.25, y=0.25},
	collisionbox = {-0.12, -0.12, -0.12, 0.12, 0.12, 0.12},
	visual = "cube",
	textures = {"default_stone.png","default_stone.png","default_stone.png","default_stone.png","default_stone.png","default_stone.png"},
	initial_sprite_basepos = {},
	is_visible = true,
	makes_footstep_sound = true,
	automatic_rotate = false,
	on_step=function(self,dtime)
		local pos=self.object:getpos()
		local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 1)
		if objs~=nil  then
			if objs[1]:is_player() then
			minetest.sound_play("a", {
				pos = pos;
				gain = 3;
				max_hear_distance = 50;
			})
				self.object:remove()
			objs[1]:set_hp(objs[1]:get_hp()-1)

			
			end
		end
	end,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nodevil:stone",
	wherein        = "default:stone",
	clust_scarcity = 14*14*14,
	clust_num_ores = 2,
	clust_size     = 2,
	height_min     = -31000,
	height_max     = 100,
	flags          = "absheight",
})