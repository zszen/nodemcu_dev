PWMPin = 1
PWMStep = 30
PWMMax = 1023-PWMStep
PWMVal = PWMMax
SWITCH = 0

pwm.setup(PWMPin, 200, PWMVal)
pwm.start(PWMPin)


function changePWM()
    if SWITCH>0 then
        if PWMVal<PWMMax then
            PWMVal=PWMVal+PWMStep
            pwm.setduty(PWMPin, PWMVal)
        else 
            SWITCH = 1-SWITCH
        end
    else 
        if PWMVal>PWMStep then
            PWMVal=PWMVal-PWMStep
            pwm.setduty(PWMPin, PWMVal)
        elseif PWMVal>0 then
            PWMVal=0
            pwm.setduty(PWMPin, PWMVal)
        else 
            SWITCH = 1-SWITCH
        end
    end
end

tmr.stop(2)
tmr.alarm(2, 50, tmr.ALARM_AUTO , changePWM)