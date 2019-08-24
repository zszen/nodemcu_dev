
gpio.mode(5,gpio.INT)

function trigRadarCheck()
    if gpio.read(5)==1 then
        print("result: radar is detected somebody")
    else
        print("result: radar is quiet")
    end
end

--function trigRadarAbleCheck()
--    print("result: radar is quit")
--end

--gpio.trig(5,"down",trigRadarAbleCheck)
gpio.trig(5,"both",trigRadarCheck)

--function timerCheck()
--    print("init radar port(5) status:"..gpio.read(5))
--end
--tmr.stop(0)
--tmr.alarm(0,200,tmr.ALARM_AUTO,timerCheck)