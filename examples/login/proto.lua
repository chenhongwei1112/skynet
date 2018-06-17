local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
  type 0 : integer
  session 1 : integer
}

handshake 1 {
  response {
    msg 0  : string
  }
}

get 2 {
  request {
    what 0 : string
  }
  response {
    result 0 : string
  }
}

set 3 {
  request {
    what 0 : string
    value 1 : string
  }
}

quit 4 {}

addMoney 5{
  request {
    money 0 : integer
  }
  response {
    money 0 : integer
  }
}

.ItemInfo{
  id 0 : integer
  param1 1 : integer
  param2 2 : string
}

jinglian 6{
  request {
    items 0 : *ItemInfo
  }
  response {
    items 0 : *ItemInfo
  }
}

foobar 7 {
  request {
    what 0 : string
  }
  response {
    ok 0 : integer
  }
}

login 8 {
  request {
   username 0 : string
   pwd 1 : string
  }
  response {
   ok 0 : boolean
   msg 1 : string
  }
}

login2 9 {
  request {
    account 0 : string
  }
  response {
    result 0 : boolean
    e_info 1 : integer
    id 2 : integer
    card_num 3 : integer
  }
}

register 10 {
  request {
    account 0 : string
  }
  response {
    result 0 : boolean
    e_info 1 : integer
  }
}

create_room 11 {
  request {
    room_type   0 : integer     # 1.房卡 2.金币
    room_passwd 1 : string    # 房间密码
    num_of_game 2 : integer   # 游戏局数
    hu_type   3 : integer   # 1:自摸 / 2:放炮胡
    ding_pao  4 : integer   # 定跑 4 / 8
    qiang_gang_hu 5 : boolean   # 是否有抢杠胡
    have_hun  6 : boolean   # 是否有混牌(癞子)
    gang_fen  7 : boolean   # 是否有杠分
    sevendui_2  8 : boolean   # 七对胡是否翻倍
    gangkai_2   9 : boolean   # 杠开赢分是不是翻倍
  }
  response {
    result 0 : boolean
    e_info 1 : integer
    room_id 2 : string
  }
}

join_room 12 {
  request {
    room_id 0 : string
    room_passwd 1 : string
  }
  response {
    result 0 : boolean
    e_info 1 : integer
  }
}

ready 13 {}

cancel_ready 14 {}

xiapao 15 {
  request {
    num 0 : integer
  }
}

out_mj 16 {
  request {
    mj_id 0 : integer
  }
}

pass 17 {}

peng 18 {}

ming_gang 19 {}

hu 20 {}

zimo 21 {
  request {
    hu_type 0 : integer
  }
}

gang 22 {
  request {
    mj_id 0 : integer
  }
}

req_dissolver_room 23 {}

res_dissolver 24 {
  request {
    agree 0 : boolean
  }
}

heartbeat 25 {
  request {
    what 0 : string
  }
  response {
    ok 0 : boolean
  }
}

reconnect 26 {
  request {
    p_id 0 : integer
    room_id 1 : integer
  }
  response {
    result 0 : boolean
    e_info 1 : integer
  }
}

info 27 {} # 调试

request_msg 28 {}

mytest 29 {}
mytest 30 {}

]]

proto.s2c = sprotoparser.parse [[
.package {
  type 0 : integer
  session 1 : integer
}

heartbeat 1 {}

create_room_succ 2 {
  request {
    result 0 : integer
    room_id 1 : integer
  }
}

player_join 3 {
  request {
    id 0 : integer
    account 1 : string
  }
}

player_ready 4 {
  request {
    id 0 : integer
  }
}

player_cancel_ready 5 {
  request {
    id 0 : integer
  }
}

player_xiapao 6 {
  request {
    id 0 : integer
    num 1 : integer
  }
}

begin_game 7 {
  request {
    banker_cid 0 : integer  #庄家椅子号
    mj_ids 1 : *integer
  }
}

# 发牌
deal 8 {
  request {
    accepter_id 0 : integer
    mj_id 1 : integer
    hu_type 2 : integer
    gangs 3 : *integer  #可能有多个暗杠 / 补杠
  }
}

player_out_mj 9 {
  request {
    player_id 0 : integer
    mj_id 1 : integer
    has_hu 2 : boolean
    has_ming_gang 3 : boolean
    has_peng 4 : boolean
  }
}

player_peng 10 {
  request {
    p_id 0 : integer
    mj_id 1 : integer
  }
}

player_ming_gang 11 {
  request {
    p_id 0 : integer
    mj_id 1 : integer
  }
}


player_hu 12 {
  request {
    p_id 0 : integer
    mjs 1 : integer
  }
}

player_zimo 13 {
  request {
    p_id 0 : integer
    mj_ids 1 : *integer
    hu_type 2 : integer
  }
}

player_gang 14 {
  request {
    p_id 0 : integer
    mj_id 1 : integer
  }
}

.Player_Score{
  p_id 0 : integer
  score 1 : integer
}
game_over 15 {
  request {
    player_scores 0 : *Player_Score
  }
}

# 解散房间
dissolver_room 16 {}

# 定跑
please_dingpao 17 {}

# 流局
liu_ju 18 {}

#抢杠胡
you_has_hu 19 {
  request {
    mj_id 0 : integer
  }
}

please_ready 20 {}

player_req_dissolver_room 21 {}

dissolver_room_suc 22 {} #解散房间成功

dissolver_room_fal 23 {} #解散房间失败

]]

return proto
