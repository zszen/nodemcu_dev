LED_PIN = 0
US_TO_MS = 1000
gpio.mode(LED_PIN, gpio.OUTPUT)

while true do
   gpio.write(LED_PIN, gpio.HIGH)
   tmr.delay(500 * US_TO_MS)
   gpio.write(LED_PIN, gpio.LOW)
   tmr.delay(500 * US_TO_MS)
end
  