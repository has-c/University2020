NO2.223.pred = 31.7838298 + (0.0061339 * 223) + (0.0018856 * 143) + (-0.1121256) + (0.8996494 * 331.7)
print(NO2.223.pred)

NO2.224.pred = 31.7838298 + (0.0061339 * 224) + (0.0018856 * 144) + (-0.0677393) + (0.8996494 * NO2.223.pred)
print(NO2.224.pred)

output = data.frame("time"=c("2019.7","2019.8","2019.9","2019.10"),
                    "actual"= c(331.9, 331.9,331.9,332.1),
                    "pred"=c(NO2.223.pred,NO2.224.pred, 331.9300,332.0974))

RMSEP = sqrt(1/4*sum((output$actual-output$pred)^2))
print(RMSEP)