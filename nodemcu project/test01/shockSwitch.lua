GSPin = 5
PWMPin = 1
PWMMax = 500
PWMVal = PWMMax
PWMStep = 25
SWITCH = 0

function turnOff()
    SWITCH = 0
end

function onBtnEvent()
    print("shack changed")
    SWITCH = 1-SWITCH
    gpio.mode(GSPin, gpio.OUTPUT)
    tmr.stop(1)
    tmr.alarm(1, 1000, tmr.ALARM_SINGLE, changeDeviceMode)
    if SWITCH>0 then
        tmr.stop(3)
        tmr.alarm(3, 3600000, tmr.ALARM_SINGLE, turnOff)
    end
end

function changeDeviceMode()
    print("shack enable detected")
    gpio.mode(GSPin, gpio.INT, gpio.PULLUP)
    gpio.trig(GSPin, "both", onBtnEvent)
end

changeDeviceMode()

pwm.setup(PWMPin, 500, PWMVal)
pwm.start(PWMPin)

function changePWM()
    if SWITCH>0 then
        if PWMVal<PWMMax then
            PWMVal=PWMVal+PWMStep
            pwm.setduty(PWMPin, PWMVal)
        end
    else 
        if PWMVal>PWMStep then
            PWMVal=PWMVal-PWMStep
            pwm.setduty(PWMPin, PWMVal)
        elseif PWMVal>0 then
            PWMVal=0
            pwm.setduty(PWMPin, PWMVal)
        end
    end
end

tmr.stop(2)
tmr.alarm(2, 50, tmr.ALARM_AUTO , changePWM)
