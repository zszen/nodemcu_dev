led_num = 4
ledsDirection = {}
ledsBrightnessTarget = {}
ledsBrightnessTarget2 = {}
ledsBrightnessTarget3 = {}
ledsBrightness = {}
ledsBrightness2 = {}
ledsBrightness3 = {}
ledsPool = {}
--is501Actived = false
duringTime = 20000
LedMode = 1

gpio.mode(5,gpio.INT)
gpio.mode(3,gpio.INT)

--function trigCheck501()
--    if gpio.read(5)==1 then
--        print("changing")
--        is501Actived = true
--        LedMode = node.random(1,2)
--        tmr.stop(0)
--        tmr.stop(1)
--        tmr.alarm(0,duringTime,tmr.ALARM_SINGLE,turnOff)
--        tmr.alarm(1,30,tmr.ALARM_AUTO,loopLed)
--    end
--end

function trigRadarCheck()
    if gpio.read(5)==1 then
        print("result: radar is detected somebody")
        --
        is501Actived = true
        LedMode = node.random(1,2)
        tmr.stop(0)
        tmr.stop(1)
        tmr.alarm(0,duringTime,tmr.ALARM_SINGLE,turnOff)
        tmr.alarm(1,30,tmr.ALARM_AUTO,loopLed)
    else
        print("result: radar is quiet")
    end
end

function trigModeChange() 
    if gpio.read(3)==0 then
        LedMode=LedMode+1
        if LedMode>2 then 
            LedMode=1
        end
    end
    print("mode",LedMode)
end



function setInit()
    for i=0, led_num do
        ledsBrightnessTarget[i] = node.random(0,255)
        ledsBrightnessTarget2[i] = node.random(0,100)
        ledsBrightnessTarget3[i] = node.random(0,200)
        ledsDirection[i] = node.random(0,1)
        ledsBrightness[i] = 0
        ledsBrightness2[i] = 0
        ledsBrightness3[i] = 0
    end 
    ws2801.init(5,4)
    setAll(string.char(0, 0, 0), led_num)
    updateAll(ledsPool, led_num)
    
    tmr.stop(0)
    tmr.stop(1)
end
 
function setAll(v, n)
    for i=0, n do
        ledsPool[i] = v
    end 
end
 
function setOne(v, n)
    ledsPool[n] = v
end

function updateAll(v, n)
    str = ""
  for i=0, n do
    if v[i] ~= nil then
        str = str .. v[i]
    end
  end
  ws2801.write(str)
  tmr.delay(100)
end

function turnOff()
    print("turnoff")
    is501Actived = false
end

function channelOne(nowVal,targetVal,maxVal)
    targetChanged=false
    if is501Actived then
        if targetVal-nowVal==0 then 
            direct = 0
        else
            direct = math.abs(targetVal-nowVal)/(targetVal-nowVal)
        end
    else
        targetVal = 0
        direct = -1
    end
    nowVal = nowVal + direct*3
    if math.abs(nowVal-targetVal)<5 then
        if is501Actived then
            targetChanged = true
            if targetVal>100 then
                targetVal = 1--node.random(0,50)
            else
                targetVal = node.random(50,maxVal)
            end
        else 
            nowVal = 0
        end
    end 
    return nowVal,targetChanged,targetVal
end

function loopLed() 
--    print("loop me")
    for i=0,led_num do
        if LedMode==1 then
            ledsBrightness[i],isChangedTarget,targetVal = channelOne(ledsBrightness[i],ledsBrightnessTarget[i],255)
            if isChangedTarget then
                ledsBrightnessTarget[i] = targetVal
            end
    --        print("value",ledsBrightness[i])
            setOne(string.char(ledsBrightness[i], ledsBrightness[i], ledsBrightness[i]), i) 
        elseif LedMode==2 then
            ledsBrightness[i],isChangedTarget,targetVal = channelOne(ledsBrightness[i],ledsBrightnessTarget[i],255)
            if isChangedTarget then
                ledsBrightnessTarget[i] = targetVal
            end 
            ledsBrightness2[i],isChangedTarget,targetVal = channelOne(ledsBrightness2[i],ledsBrightnessTarget2[i],100)
            if isChangedTarget then
                ledsBrightnessTarget2[i] = targetVal
            end
            ledsBrightness3[i],isChangedTarget,targetVal = channelOne(ledsBrightness3[i],ledsBrightnessTarget3[i],200)
            if isChangedTarget then
                ledsBrightnessTarget3[i] = targetVal
            end
            setOne(string.char(ledsBrightness[i], ledsBrightness2[i], ledsBrightness3[i]), i) 
        end
    end
    updateAll(ledsPool, led_num)

    isAllZero = true
    for i=0,led_num do
        if ledsBrightness[i]~=0 then
            isAllZero = false
            break
        end
        if LedMode==2 then
            if ledsBrightness2[i]~=0 then
                isAllZero = false
                break
            end
            if ledsBrightness3[i]~=0 then
                isAllZero = false
                break
            end
        end
    end
    if isAllZero then
        print("loopled end")
        tmr.stop(1)
    end
end 

setInit();
--gpio.trig(5,"both",trigCheck501)
gpio.trig(5,"both",trigRadarCheck)
gpio.trig(3,"up",trigModeChange)
--tmr.alarm(0,duringTime,tmr.ALARM_SINGLE,turnOff)
--tmr.alarm(1,30,tmr.ALARM_AUTO,loopLed)

--LedMode = node.random(1,2)
--tmr.stop(0)
--tmr.stop(1)
--tmr.alarm(0,duringTime,tmr.ALARM_SINGLE,turnOff)
--tmr.alarm(1,30,tmr.ALARM_AUTO,loopLed)

print("Starting Product....")
