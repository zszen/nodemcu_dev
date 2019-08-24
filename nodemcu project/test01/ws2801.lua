
ws2801.init(4,2)
ws2801.write(string.char(0,0,0):rep(100))


function HSL(hue, saturation, lightness)
    local chroma = (1 - math.abs(2 * lightness - 1)) * saturation
    local h = hue/60
    local x =(1 - math.abs(h % 2 - 1)) * chroma
    local r, g, b = 0, 0, 0
    if h < 1 then
        r,g,b=chroma,x,0
    elseif h < 2 then
        r,b,g=x,chroma,0
    elseif h < 3 then
        r,g,b=0,chroma,x
    elseif h < 4 then
        r,g,b=0,x,chroma
    elseif h < 5 then
        r,g,b=x,0,chroma
    else
        r,g,b=chroma,0,x
    end
    local m = lightness - chroma/2
    return math.floor((r+m)*255),math.floor((g+m)*255),math.floor((b+m)*255)
end

turntype =4
loopNum = 0
direction = 1

--tmr.delay(1000000)
--ws2801.write(string.char(0,50,0))

ledNum = 25
ledColors = ledNum*3

ledPool = {}
ledPoolTo = {}
for i=1, ledColors,3 do
    ledPool[i] = 0
    ledPool[i+1] = 0
    ledPool[i+2] = 0
    local cr,cg,cb = HSL(math.random(0,255),1,.1)
    ledPoolTo[i]=cr
    ledPoolTo[i+1]=cg
    ledPoolTo[i+2]=cb
--    ledPoolTo[i]=math.random(65,90)
--    print(cr,cg,cb)
end

function turnLed()
    local str = ""
    for i=1, ledColors, 3 do
--        ledPool[i]=ledPool[i]+(ledPoolTo[i]-ledPool[i])/10
--        ledPool[i+1]=ledPool[i+1]+(ledPoolTo[i+1]-ledPool[i+1])/10
--        ledPool[i+2]=ledPool[i+2]+(ledPoolTo[i+2]-ledPool[i+2])/10
        str=str..string.char(ledPoolTo[i],ledPoolTo[i+1],ledPoolTo[i+2])
    end
    ws2801.write(str)
--    print(str)
end

function turnLedTo()
    local str = ""
    if turntype==1 then
        for i=1, ledColors, 3 do
            local cr,cg,cb = HSL(math.random(0,255),1,.05)
            ledPoolTo[i]=cr
            ledPoolTo[i+1]=cg
            ledPoolTo[i+2]=cb
            str=str..string.char(ledPoolTo[i],ledPoolTo[i+1],ledPoolTo[i+2])
        end
    elseif turntype==3 then
        loopNum=(loopNum+1)%4
        for i=1, ledColors, 3 do
            if (i+loopNum)%4~=0 then
                str=str..string.char(0,0,0)
            else
                local cr,cg,cb = HSL(math.random(0,255),1,.05)
                ledPoolTo[i]=cr
                ledPoolTo[i+1]=cg
                ledPoolTo[i+2]=cb
                str=str..string.char(ledPoolTo[i],ledPoolTo[i+1],ledPoolTo[i+2])
            end
        end
    elseif turntype==2 then
        loopNum=(loopNum+1)%ledNum
        for i=1, ledColors, 3 do
            if i~=(loopNum*3+1) then
                str=str..string.char(0,0,0)
            else
                local cr,cg,cb = HSL(math.random(0,255),1,.05)
                ledPoolTo[i]=cr
                ledPoolTo[i+1]=cg
                ledPoolTo[i+2]=cb
                str=str..string.char(ledPoolTo[i],ledPoolTo[i+1],ledPoolTo[i+2])
            end
        end
    elseif turntype==4 then
        if math.random(0,100)>90 then
            direction = -direction
        end
        loopNum=loopNum+direction
        if loopNum<0 then
            loopNum = ledNum-1
        elseif loopNum>=ledNum then
            loopNum = 0
        end
        for i=1, ledColors, 3 do
            if i~=(loopNum*3+1) then
                str=str..string.char(0,0,0)
            else
                local cr,cg,cb = HSL(math.random(0,255),1,.05)
                ledPoolTo[i]=cr
                ledPoolTo[i+1]=cg
                ledPoolTo[i+2]=cb
                str=str..string.char(ledPoolTo[i],ledPoolTo[i+1],ledPoolTo[i+2])
            end
        end
    end
    ws2801.write(str)
end

--tmr.stop(0)
--tmr.alarm(0, 50, tmr.ALARM_AUTO, turnLed)
tmr.stop(1)
tmr.alarm(1, 50, tmr.ALARM_AUTO, turnLedTo)

function onBtnEvent()
    local tt = turntype-1
    tt=(tt+1)%4
    turntype=tt+1
    print(turntype)
    if turntype==2 then
        tmr.stop(1)
        tmr.alarm(1, 100, tmr.ALARM_AUTO, turnLedTo)
    elseif turntype==4 then
        tmr.stop(1)
        tmr.alarm(1, 50, tmr.ALARM_AUTO, turnLedTo)
    elseif turntype==3 then
        tmr.stop(1)
        tmr.alarm(1, 1000, tmr.ALARM_AUTO, turnLedTo)
    else
        tmr.stop(1)
        tmr.alarm(1, 2000, tmr.ALARM_AUTO, turnLedTo)
    end
end
gpio.mode(3, gpio.INT, gpio.PULLUP)
gpio.trig(3, "up", onBtnEvent)

--color1 = HSL(100,.5,.5)
--print(color1[0])
--print(color1[1])
--print(color1[2])
