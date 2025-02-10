
--py函数库
require 'python'
Python = python
GameAPI = gameapi
GlobalAPI = globalapi
Fix32Vec3 = Fix32Vec3
Fix32 = Fix32
New_global_trigger = new_global_trigger
New_modifier_trigger = new_modifier_trigger
New_item_trigger = new_item_trigger


local setmetatable = setmetatable

local new_trigger = new_global_trigger(357433896, "游戏 - 游戏初始化", "ET_GAME_INIT", true)
new_trigger.on_event = function(trigger,event_name,actor,data)
	GameAPI.set_render_option("EnableSunLightShadow", 1)
    GameAPI.set_render_option("ShadowCameraFrustrumRange", 50)
    GameAPI.set_render_option("DynamicShadowDistanceMovableLight", 50)
    GameAPI.set_render_option("FocusDistance", 50)
    GameAPI.set_render_option("EnableEnvRendering", 0)
end

up = {}
function up.print(...)
    local str = ''
    local t = {...}
    for i = 1, #t - 1 do
        str = str .. tostring(t[i]) .. '    '
    end
    str = str .. tostring(t[#t])
    gameapi.print_to_dialog(3,str)
end
print = up.print


local a_type = {
    [0]= '隐藏',
    [1] = '普攻',
    [2] = '通用',
    [3] = '英雄',
}

local new_trigger = new_global_trigger(1000000, "玩家-关闭技能指示器", "ET_STOP_SKILL_POINTER", true)
new_trigger.on_event = function(trigger,event_name,actor,data)
    print('!!!!!!!!!!!!')
    local player = data['__role_id']
    local unit_id = data['__unit_id']
    local a_type = data['__ability_type']
    local a_id = data['__ability_index']
    local unit = gameapi.get_unit_by_id(unit_id)
    print('a_type',a_type,'a_id',a_id,'unit',unit)
    local skill = unit:api_get_ability(a_type,a_id)

    gameapi.send_event_custom(1172206038, gameapi.gen_param_dict(gameapi.gen_param_dict({}, "玩家", gameapi.get_role_by_role_id(player)), "技能", skill))
end


-- params=((EParams.ABILITY, EType.Ability, '技能'),
-- (EParams.ABILITY_TYPE, EType.AbilityType, '技能类型'),
-- (EParams.ABILITY_INDEX, EType.AbilityIndex, '技能ID'),
-- (EParams.ABILITY_SEQ, EType.AbilitySeq, '技能Seq'),
-- (EParams.UNIT_ID, EType.UnitID, "主人"),
-- (EParams.BUILD_UNIT_ID, EType.UnitID, "建造出来的单位ID")),

local new_trigger = new_global_trigger(1000001, "单位-建造", "ET_ABILITY_BUILD_FINISH", true)
new_trigger.on_event = function(trigger,event_name,actor,data)
    print('!!!!!!!!!!!!')
    local unit_id = data['__unit_id']
    local build_unit_id = data['__build_unit_id']
    local skill =  data['__ability']
    print(skill)
    local unit = gameapi.get_unit_by_id(unit_id)
    local build_unit = gameapi.get_unit_by_id(build_unit_id)
    gameapi.send_event_custom(1402924002, gameapi.gen_param_dict(gameapi.gen_param_dict(gameapi.gen_param_dict({}, "玩家",unit:api_get_role()), "建造单位", build_unit), "建造技能", skill))
end
