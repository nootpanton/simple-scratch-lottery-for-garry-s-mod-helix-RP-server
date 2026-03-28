local MAX_USES = 5

ITEM.name = "lottery box"
ITEM.model = "models/lottery_ticket_box/lottery_ticket_box.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 100
ITEM.flag = "v"

ITEM.data = {
    uses = MAX_USES
}

function ITEM:GetDescription()
    local uses = self:GetData("uses", MAX_USES)
    return "복권 " .. uses .. "장이 들어있는 작은 상자입니다. 소문에 의하면 1000토큰 짜리 당첨금이 있다고 합니다."
end

local rewards = {
    { chance = 7460, item = nil,			  message = "Unfortunately... you lose.", sound = "buttons/lever7.wav" },
    { chance = 2270, item = "lotterywin50",   message = "You win 50 tokens.", sound = "buttons/lever7.wav" },
    { chance = 245,  item = "lotterywin100",  message = "You win 100 tokens!", sound = "buttons/lever7.wav" },
    { chance = 120,   item = "lotterywin500",  message = "Oh god, You win 500 tokens!", sound = "ambient/alarms/warningbell1.wav" },
	{ chance = 25,	 item = "lotterywin1000", message = "Lady Luck is smiling on you today! You've won a whopping 1,000 tokens!", sound = "ambient/alarms/warningbell1.wav" },
}
	
ITEM.functions = ITEM.functions or {}

ITEM.functions.Use = {
    name = "pick up and scratch",

    OnCanRun = function(item)
        return item:GetData("uses", MAX_USES) > 0
    end,

    OnRun = function(item, client)
        local player = item:GetOwner()
        if not IsValid(player) then return false end

        local char = player:GetCharacter()
        if not char then return false end

        local uses = item:GetData("uses", MAX_USES)

        local roll = math.random(10000)
        local total = 0
        local prize = rewards[1]

        for _, v in ipairs(rewards) do
            total = total + v.chance
            if roll <= total then
                prize = v
                break
            end
        end

        if prize.item then
            char:GetInventory():Add(prize.item)
        end

        if prize.sound then
            player:EmitSound(prize.sound)
        end

        player:Notify(prize.message)

        uses = uses - 1
        item:SetData("uses", uses)


        if uses <= 0 then
            return true
        end

        return false
    end,
}