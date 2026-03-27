
ITEM.name = "즉석 복권"
ITEM.description = "복권을 긁고 당신의 행운을 시험해보세요."
ITEM.model = "models/lottery_ticket/lottery_ticket.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 20
ITEM.flag = "v"

local rewards = {
    { chance = 740, item = nil, message = "아쉽게도... 꽝입니다.", sound = "buttons/lever7.wav"  },
    { chance = 230, item = "lotterywin50",  message = "50 토큰에 당첨되었습니다.", sound = "buttons/lever7.wav" },
    { chance = 25, item = "lotterywin100", message = "100 토큰에 당첨되었습니다!", sound = "buttons/lever7.wav" },
    { chance = 5,  item = "lotterywin500", message = "세상에, 500 토큰에 당첨되셨습니다!", sound = "ambient/alarms/warningbell1.wav" },
}

ITEM.functions = ITEM.functions or {}
ITEM.functions.Use = {
    name = "복권 긁기",
    OnCanRun = function(item, client)
        return true
    end,
    OnRun = function(item, client)
        local player = item:GetOwner()
        if not IsValid(player) then return false end

        local char = player:GetCharacter()
        if not char then return false end

        local roll = math.random(1000)
        local total = 0
        local prize = rewards[1]

        for _, v in ipairs(rewards) do
            total = total + v.chance
            if roll <= total then
                prize = v
                break
            end
        end

        char:GetInventory():Remove(item.uniqueID, 1)

        if prize.item then
            char:GetInventory():Add(prize.item)
        end

        if prize.sound then
            player:EmitSound(prize.sound)
        end

        player:Notify(prize.message)

        return true
    end,
}
